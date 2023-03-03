# Quick Start

1. `docker-compose up -d`
1. `pnpm install`
1. `pnpm prisma:development generate --data-proxy`
1. `pnpm dev`

You should see an error like the following get produced:

<img width="1281" alt="CleanShot 2023-03-03 at 12 28 53@2x" src="https://user-images.githubusercontent.com/284476/222788140-40fc7d7d-ea3c-43d6-bd17-de75e6fc295a.png">

Notice the second error's stack including the generated edge prisma client.

Note that both errors go away when removing the Prisma Client constructor call.
