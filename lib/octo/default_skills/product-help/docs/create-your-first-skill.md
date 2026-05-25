# Create Your First Skill

## Step 1: Create the Skill Directory

```bash
mkdir -p ~/.octo/skills/hello-world
```

## Step 2: Write SKILL.md

```bash
cat > ~/.octo/skills/hello-world/SKILL.md << 'EOF'
---
name: hello-world
description: 'Use this skill when the user wants a greeting'
---

# Hello World Skill

When invoked, greet the user warmly and ask how you can help today.
EOF
```

## Step 3: Test It

Start octo and invoke your skill:

```bash
$ octo
> /hello-world
```

## Step 4: Iterate

Refine the instructions based on how the agent behaves. Add more detail, examples, or constraints.

## Step 5: Share (Optional)

Skills are plain Markdown. Zip the directory and share it:

```bash
cd ~/.octo/skills && zip -r hello-world.zip hello-world/
```

Others can install it with `/skill-add hello-world.zip`.

That's it — no compilation, no registration, no encryption keys.
