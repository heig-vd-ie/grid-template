# Roles

- Owner (xxx): Final authority on repository lifecycle, access, and policy.
- Moderator (xxx): Day-to-day control of reviews, merges, and access requests.
- Developer (xxx): Writes code and documentation.

# Decision Matrix

```
Action                           | Owner | Moderator | Developer
---------------------------------|-------|-----------|-----------
Create repository                | A     | R         | I
Archive or delete repository     | A     | R         | I
Grant or revoke access           | A     | R         | I
Change branch protection rules   | A     | R         | I
Merge pull request to main       | A     | R         | R
Create or publish tags/release   | A     | R         | R
```
