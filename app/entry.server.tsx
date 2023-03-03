import { RemixServer } from '@remix-run/react'
import isBot from 'isbot'
import type { Entry } from 'lib/remix-plus/RemixPlus'
import { renderToReadableStream } from 'react-dom/server'

const entry: Entry = async (
  request,
  responseStatusCode,
  responseHeaders,
  remixContext
) => {
  const stream = await renderToReadableStream(
    <RemixServer context={remixContext} url={request.url} />,
    {
      signal: request.signal,
      onError: (error: unknown) => {
        responseStatusCode = 500
        console.error(error)
      },
    }
  )

  if (isBot(request.headers.get(`user-agent`))) {
    await stream.allReady
  }

  responseHeaders.set(`Content-Type`, `text/html`)

  return new Response(stream, {
    headers: responseHeaders,
    status: responseStatusCode,
  })
}

export default entry
