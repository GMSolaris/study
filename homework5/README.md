

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.
```
myagkikh@KvaziK:/mnt/c/kvazik/terraform$ git show aefea
commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
Date: Thu Jun 18 10:29:58 2020 -0400
Update CHANGELOG.md
diff --git a/CHANGELOG.md b/CHANGELOG.md
index 86d70e3e0..588d807b1 100644
--- a/CHANGELOG.md
+++ b/CHANGELOG.md 
@@ -27,6 +27,7 @@ BUG FIXES: 
* backend/s3: Prefer AWS shared configuration over EC2 metadata credentials by default ([#25134](https://github.com/hashicorp/terraform/issues/25134)) 
* backend/s3: Prefer ECS credentials over EC2 metadata credentials by default ([#25134](https://github.com/hashicorp/terraform/issues/25134)) 
* backend/s3: Remove hardcoded AWS Provider messaging ([#25134](https://github.com/hashicorp/terraform/issues/25134)) 
+* command: Fix bug with global `-v`/`-version`/`--version` flags introduced in 0.13.0beta2 [GH-25277] 
* command/0.13upgrade: Fix `0.13upgrade` usage help text to include options ([#25127](https://github.com/hashicorp/terraform/issues/25127)) 
* command/0.13upgrade: Do not add source for builtin provider ([#25215](https://github.com/hashicorp/terraform/issues/25215)) 
* command/apply: Fix bug which caused Terraform to silently exit on Windows when using absolute plan path ([#25233](https://github.com/hashicorp/terraform/issues/25233)) 

```

Полный хеш коммита aefead2207ef7e2aa5dc81a34aedf0cad4c32545 

2. Какому тегу соответствует коммит 85024d3?
```
myagkikh@KvaziK:/mnt/c/kvazik/terraform$ git show 85024d3 commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23) 
```
Коммит соответствует тегу v0.12.23

3. Сколько родителей у коммита b8d720? Напишите их хеши.
```
myagkikh@KvaziK:/mnt/c/kvazik/terraform$ git show b8d720^ 
commit 56cd7859e05c36c06b56d013b55a252d0bb7e158 Merge: 58dcac4b7 ffbcf5581 
Author: Chris Griggs <cgriggs@hashicorp.com> 
Date: Mon Jan 13 13:19:09 2020 -0800 
Merge pull request #23857 from hashicorp/cgriggs01-stable [cherry-pick]add checkpoint links 
```
родительские коммиты имеют хеши 58dcac4b7 и ffbcf5581. Коммит b8d720 образован мерджем двух родительских коммитов.

4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.

```
myagkikh@KvaziK:/mnt/c/kvazik/terraform$ git log v0.12.23..v0.12.24 --oneline 
33ff1c03b (tag: v0.12.24) v0.12.24 b14b74c49 [Website] vmc provider links 
3f235065b Update CHANGELOG.md 
6ae64e247 registry: Fix panic when server is unreachable 
5c619ca1b website: Remove links to the getting started guide's old location 
06275647e Update CHANGELOG.md 
d5f9411f5 command: Fix bug when using terraform login on Windows 
4b6d06cc5 Update CHANGELOG.md dd01a3507 Update CHANGELOG.md 
225466bc3 Cleanup after v0.12.23 release 
```
Хеши коммитов между тегами 
* 225466bc3
* dd01a3507
* d5f9411f5
* 6ae64e247
* 3f235065b

5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).
```
myagkikh@KvaziK:/mnt/c/kvazik/terraform$ git log -S providerSource --oneline
 5b266dd5c command: Remove the experimental "terraform add" command 
 c587384df cli: Restore -lock and -lock-timeout init flags 
 583859e51 commands: `terraform add` (#28874) 
 5f30efe85 command tests: plan and init (#28616) 
 c89004d22 core: Add sensitive provider attrs to JSON plan 
 31a5aa187 command/init: Add a new flag `-lockfile=readonly` (#27630) 
 bab497912 command/init: Remove the warnings about the "legacy" cache directory 
 e70ab09bf command: new cache directory .terraform/providers for providers 
 b3f5c7f1e command/init: Read, respect, and update provider dependency locks 
 0b734a280 command: Make provider installation interruptible 
 command: Better in-house provider install errors 
 d8e996436 terraform: Eval module call arguments for import 
 87d1fb400 command/init: Display provider validation errors 
 6b3d0ee64 add test for terraform version 
 dbe139e61 add test for terraform version -json 
 b611bd720 reproduction test 
 8b279b6f3 plugin/discovery: Remove dead code 
 ca4010706 command/init: Better diagnostics for provider 404s 
 62d826e06 command/init: Use full config for provider reqs 
 ae98bd12a command: Rework 0.13upgrade sub-command 
 5af1e6234 main: Honor explicit provider_installation CLI config when present 
 269d51148 command/providers: refactor with new provider types and functions 
 8c928e835 main: Consult local directories as potential mirrors of providers 
 958ea4f7d internal/providercache: Handle built-in providers 
 de6c9ccec command/init: Move "vendored provider" test to e2etests 
 0af09b23c command: apply and most of import tests passing 
 add7006de command: Fix TestInit_pluginDirProviders and _pluginDirProvidersDoesNotGet 
 d40085f37 command: Make the tests compile again 
 3b0b29ef5 command: Add scaffold for 0.13upgrade command 
 18dd1bb4d Mildwonkey/tfconfig upgrade (#23670) 
 5e06e39fc Use registry alias to fetch providers 
```
Первый коммит где появилась данная функция 5e06e39fc

6. Найдите все коммиты в которых была изменена функция globalPluginDirs
```
myagkikh@KvaziK:/mnt/c/kvazik/terraform$ git log -S globalPluginDirs --oneline
 35a058fb3 main: configure credentials from the CLI config file 
 c0b176109 prevent log output during init 
 8364383c3 Push plugin discovery down into command package 
```

Коммиты где менялась функция globalPluginDirs
* 35a058fb3
* c0b176109
* 8364383c3

7. Кто автор функции synchronizedWriters
```
myagkikh@KvaziK:/mnt/c/kvazik/terraform$ git log -S synchronizedWriters --oneline 
bdfea50cc remove unused 
fd4f7eb0b remove prefixed io 
5ac311e2a main: synchronize writes to VT100-faker on Windows 

myagkikh@KvaziK:/mnt/c/kvazik/terraform$ git show 5ac311e2a 
commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5 Author: Martin Atkins <mart@degeneration.co.uk> Date: Wed May 3 16:25:41 2017 -0700 
```
Автор функции, если принять за автора того, кто её первым создал является Martin Atkins 
