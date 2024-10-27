# Etapa 1: Instalação de dependências e build da aplicação
FROM node:20 AS builder
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
RUN npm run build
RUN npx prisma generate
FROM node:20-slim AS runner
RUN apt-get update -y && apt-get install -y openssl
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma
EXPOSE 3000
ENV DATABASE_URL=${DATABASE_URL}
RUN npx prisma migrate deploy
CMD ["node", "dist/server.js"]
