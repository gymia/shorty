const app = require("./src/app");
const PORT = 3000;

const redis = require("redis");
const redisClient = redis.createClient({ prefix: "code:" });

app(redisClient).listen(PORT);

console.log("Listening on port %d", PORT);
