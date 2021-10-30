Начинаем домашнюю работу №3.1

1. Первым делом создадим файл .gitignore в корне проекта, чтобы исключить из коммитов все директории которые создает IDE и прочие инструменты. Все директории начинающиеся с . не попадают в коммиты.


2. Подключаем настраиваем еще один внешний репозиторий на gitlab, прописываем ключи ssh, создаем репозиторий, подключаем его как внеший репозиторий.
```
kvazik@kvazik-matebook:/mnt/c/gmsolaris$ git remote -v
gitlab  git@gitlab.com:GMSolaris/study.git (fetch)
gitlab  git@gitlab.com:GMSolaris/study.git (push)
origin  git@github.com:GMSolaris/study.git (fetch)
origin  git@github.com:GMSolaris/study.git (push)
```

3. Подключаем настраиваем еще один внешний репозиторий на bitbucket, прописываем ключи ssh, создаем репозиторий, подключаем его как внеший репозиторий.
```
kvazik@kvazik-matebook:/mnt/c/gmsolaris/study$ git remote -v
bb      git@bitbucket.org:gmsolaris/study.git (fetch)
bb      git@bitbucket.org:gmsolaris/study.git (push)
gitlab  git@gitlab.com:GMSolaris/study.git (fetch)
gitlab  git@gitlab.com:GMSolaris/study.git (push)
origin  git@github.com:GMsolaris/study.git (fetch)
origin  git@github.com:GMsolaris/study.git (push)
```
4. Пушим наш проект со всеми коммитами на все три внешних репозитория

№3.2

1. Добавляем два тега к коммиту и пушим в три upstream.