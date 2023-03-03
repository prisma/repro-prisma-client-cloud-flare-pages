import { useLoaderData } from '@remix-run/react'
import { createLoader } from 'lib/remix-plus/RemixPlus'
import { getPrisma } from 'singletons/prisma'

export const loader = createLoader(async ({ context }) => {
  if (!context.DATABASE_URL_PROXY) {
    throw new Error(`DATABASE_URL_PROXY is not set`)
  }

  console.log(`---------------------`)
  console.log(context)
  console.log(`---------------------`)

  const prisma = getPrisma({
    url: context.DATABASE_URL_PROXY,
  })

  const users = await prisma.user.findMany()

  return {
    users,
  }
})

export default () => {
  const data = useLoaderData<typeof loader>()
  return <pre>{JSON.stringify(data, null, 2)}</pre>
}
