# Etapa 1: Instalação de dependências e build da aplicação
FROM node:20 AS builder

# Configura o diretório de trabalho
WORKDIR /app

# Copia o package.json e o package-lock.json
COPY package.json ./

# Instala as dependências e as devDependencies para compilar a aplicação
RUN npm install

# Copia o restante dos arquivos do projeto
COPY . .

# Executa o build usando o tsup
RUN npm run build

# Etapa 2: Configuração da imagem final para execução
FROM node:20-slim AS runner

# Configura o diretório de trabalho
WORKDIR /app

# Copia o build e as dependências para a imagem final
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma

# Expor a porta usada pelo Fastify
EXPOSE 3000

# Variável de ambiente para a URL do banco de dados
ENV DATABASE_URL=${DATABASE_URL}

# Executa as migrações do Prisma no banco de dados
RUN npx prisma migrate deploy

# Comando para iniciar a aplicação
CMD ["node", "dist/server.js"]
