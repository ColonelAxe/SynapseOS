# Discord notifications

GitHub Actions can post commit notifications for pushes to `dev` and `main`, and notifications when a GitHub Release is published.

## One-time setup

1. In Discord, open the channel where you want SynapseOS updates.
2. Open **Edit Channel → Integrations → Webhooks → New Webhook**.
3. Give it a recognizable name, select the target channel and copy its webhook URL.
4. On GitHub, open **ColonelAxe/SynapseOS → Settings → Secrets and variables → Actions**.
5. Select **New repository secret**. Name it exactly `DISCORD_WEBHOOK_URL` and paste the URL as the secret value.
6. Save. Do not put the webhook URL in a committed file or message.

Once that secret is saved, the next push to `dev` or `main` and the next published GitHub Release should notify the selected channel. The action sends branch/release, actor and commit links; it does not send diffs or file contents.

If the secret is absent, the action skips the message. A failed webhook response marks the action run failed. Check the run under the repository's **Actions** tab.

Webhook URLs are credentials. If one is exposed, delete/regenerate it in Discord and replace the GitHub secret.
