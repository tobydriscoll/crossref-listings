Deno.chdir("_crossrefs");
const currentDirectory = Deno.cwd();

for await (const entry of Deno.readDir(currentDirectory)) {
    if (entry.isFile && entry.name.endsWith('.yml')) {
        Deno.remove(entry.name);
    }
}