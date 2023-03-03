import { PrismaClient } from '@prisma/client/edge'

export const onRequest: PagesFunction = async (ctx) => {
  console.log(ctx.env)

  new PrismaClient({
    datasources: {
      db: {
        url: ctx.env.DATABASE_URL_PROXY_2,
      },
    },
  })

  return new Response(`ok`)
}
