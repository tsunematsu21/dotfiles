{ inputs, ... }:

{
  flake.modules.homeManager.agent-skills =
    { lib, ... }:
    let
      skillPrefix = "skill-";
      agentSkills = lib.filterAttrs (name: _: lib.hasPrefix skillPrefix name) inputs;

      resolveSkill =
        name: source:
        let
          skillName = lib.removePrefix skillPrefix name;
          rootSkill = source.outPath;
          nestedSkill = "${source.outPath}/skills/${skillName}";
        in
        if builtins.pathExists "${nestedSkill}/SKILL.md" then
          {
            source = nestedSkill;
            target = ".agents/skills/${skillName}";
          }
        else if builtins.pathExists "${rootSkill}/SKILL.md" then
          {
            source = builtins.path {
              path = rootSkill;
              name = "${skillName}-skill";
              filter = path: _: builtins.baseNameOf path == "SKILL.md";
            };
            target = ".agents/skills/${skillName}";
          }
        else
          throw "No SKILL.md found for ${name}";
    in
    {
      home.file = lib.mapAttrs' (
        name: source:
        let
          skill = resolveSkill name source;
        in
        lib.nameValuePair skill.target {
          inherit (skill) source;
          force = true;
        }
      ) agentSkills;
    };
}
