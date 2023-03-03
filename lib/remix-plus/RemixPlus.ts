import type { EntryContext } from '@remix-run/cloudflare'

interface AppLoadContext {
  ASSETS: object // TODO not sure what this is, some kind of Remix thing
  DATABASE_URL_DIRECT: string
  DATABASE_URL_PROXY: string
}

interface DataFunctionArgs {
  request: Request
  context: AppLoadContext
  params: Params
}

export interface Entry {
  (
    request: Request,
    responseStatusCode: number,
    responseHeaders: Headers,
    remixContext: EntryContext
  ): Promise<Response>
}

export interface Loader<AppData> {
  (args: DataFunctionArgs):
    | Promise<Response>
    | Response
    | Promise<AppData>
    | AppData
}

// prettier-ignore
export const createLoader = <AppData>(loader: Loader<AppData>): Loader<AppData> => loader
