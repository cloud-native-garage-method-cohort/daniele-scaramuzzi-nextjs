FROM quay.io/ibmgaragecloud/node:lts-stretch AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

# Rebuild the source code only when needed
FROM quay.io/ibmgaragecloud/node:lts-stretch AS builder
WORKDIR /app
COPY pages pages
COPY public public
COPY styles styles
COPY next.config.js package.json package-lock.json ./
COPY --from=deps /app/node_modules ./node_modules
RUN npm run-script build && npm install --production --ignore-scripts --prefer-offline

# Production image, copy all the files and run next
FROM quay.io/ibmgaragecloud/node:lts-stretch AS runner
WORKDIR /app

ENV NODE_ENV production

COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000

CMD ["npm", "start"]