import { PrismaClient } from '@prisma/client/edge'

export const onRequest = async (ctx: any) => {
  console.log(ctx.env)

  try {
    new PrismaClient({
      datasources: {
        db: {
          url: ctx.env.DATABASE_URL_PROXY,
        },
      },
    })
  } catch (e: any) {
    return new Response(e.message)
  }

  return new Response(`ok`)
}
