# ── base ──────────────────────────────────────────────────────────────────────
FROM node:22-alpine AS base
RUN corepack enable && corepack prepare yarn@1.22.22 --activate
WORKDIR /app

# ── deps ──────────────────────────────────────────────────────────────────────
FROM base AS deps
COPY package.json yarn.lock* ./
RUN yarn install --frozen-lockfile

# ── builder ───────────────────────────────────────────────────────────────────
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN yarn build

# ── runner ────────────────────────────────────────────────────────────────────
FROM base AS runner
ENV NODE_ENV=production

# Non-root user
RUN addgroup --system --gid 1001 nodejs \
 && adduser  --system --uid 1001 appuser

# Production dependencies only
COPY package.json yarn.lock* ./
RUN yarn install --frozen-lockfile --production

# Compiled output
COPY --from=builder --chown=appuser:nodejs /app/dist ./dist

# Entrypoint
COPY docker-entrypoint.sh ./
RUN chmod +x docker-entrypoint.sh

USER appuser

EXPOSE 3000
ENV PORT=3000

ENTRYPOINT ["sh", "docker-entrypoint.sh"]
CMD ["node", "dist/index.js"]
