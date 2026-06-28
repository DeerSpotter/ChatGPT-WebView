# Onboarding Options

## Problem

Pure bring your own Supabase setup is secure, but it is too much work for most users.

A normal user should not have to create OAuth apps, copy callback URLs, deploy SQL migrations, deploy Edge Functions, and paste keys before they can try the app.

## Recommended product model

Use a hybrid onboarding model.

## 1. Hosted mode, default

Hosted mode is the normal public app experience.

```text
User opens app
  -> taps Continue with GitHub, Google, Apple, or Microsoft
  -> app uses the maintainer hosted Supabase memory backend
  -> Supabase Auth identifies the user
  -> RLS scopes rows to that user
  -> memory works immediately
```

The iOS app may include:

- hosted Supabase project URL
- hosted Supabase publishable key

The iOS app must never include:

- Supabase secret key
- service role key
- database password
- OAuth provider client secrets

This does not make all maintainer databases available. It only exposes the public client entry point for one purpose built hosted memory project. Access control must be enforced with Supabase Auth, RLS, and JWT protected Edge Functions.

Before hosted mode is production ready, add:

- account delete
- data export
- data delete
- privacy notice
- abuse/rate limits
- logs review

## 2. BYO Supabase mode, advanced

BYO mode remains available for advanced users who want their own isolated backend.

```text
User opens app
  -> chooses Use My Own Supabase
  -> enters project URL and publishable key
  -> deploys the memory schema and Edge Function to their project
  -> app stores memory only in that user's Supabase project
```

This mode is better for private internal use, self hosting, or users who do not want data in the hosted backend.

## First launch UX target

```text
Choose memory backend

[Continue with Hosted Memory]
Best for most users. Sign in and start using memory.

[Use My Own Supabase]
Advanced. Requires deploying the schema and Edge Function.
```

## Implementation tasks

- Add backend mode selector: Hosted / BYO.
- Keep BYO setup screen as advanced mode.
- Add hosted config constants only after a production hosted memory project is ready.
- Add clear warnings that hosted mode stores data in the maintainer hosted Supabase project.
- Add export/delete controls before marking hosted mode production ready.
- Add diagnostics for provider not enabled, missing memory function, and missing schema.

## Current Phase 2A status

Phase 2A currently implements BYO mode. That was the safer first implementation because it avoids accidentally turning the maintainer's Supabase project into the backend for every installed copy.

The next usability phase should add hosted mode as the default and keep BYO mode as Advanced Setup.
