FROM node:20
WORKDIR /app
COPY package*.json ./
RUN npm install 
COPY . .
RUN npx prisma generate
EXPOSE 3000
CMD ["npx", "prisma", "migrate", "deploy", "&&", "npm", "start"]