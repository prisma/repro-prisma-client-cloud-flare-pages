import { PrismaClient } from '@prisma/client/edge'

export const getPrisma = (params: { url: string }) =>
  new PrismaClient({
    datasources: {
      db: {
        url: params.url,
      },
    },
  })
