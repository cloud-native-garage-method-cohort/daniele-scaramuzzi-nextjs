FROM quay.io/ibmgaragecloud/node:lts-stretch  as build
WORKDIR /app
COPY ["package.json", "package-lock.json*", "./"]
RUN npm install 
COPY . .
CMD [ "npm", "start" ]
