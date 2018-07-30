# Monday Morning Music

## About This Project

Life can be hard, and Mondays can be even harder. Morning Monday Music is a site to share those singular songs that help people face the week ahead. Songs are linked to YouTube and users can register, listen, comment on and like the songs they listen to. Each user's liked songs is kept on a playlist for them to keep track of and listen to later.

## Links
[Click here to check out the Monday Morning Music](https://mondaymorningmusic.herokuapp.com)

## Approach Taken

For my second project, I wanted to deliver a usable app that would be helpful for people. In the bloated music environment on the web, it's easy to get overwhelmed by the choice of what's on offer and what to listen to. Monday Morning Music then started as an idea to have a simple space where people can share their most favourite songs, and be able to have people comment on them too. 

I started by setting up the basic template for a CRUD application (Create, Read, Update, Delete). Users having an account to keep track on songs is an important part so I focused a lot on this area and made it so that the user_id and their likes/unlikes could be stored or removed. Initially I started by embedding both Bandcamp and Youtube links into the site. The user was prompted for the track name, artist, album, artwork and song link. I found this to not be user friendly so I decided to utilise the Last.FM API so I could fetch the artwork and the album data. This meant that users could then just give the title, artist and song link. I also decided that the song link should auto-embed from the url on Youtube as finding the emded code was a little time consuming for the user. Due to this I decided to only you Youtube links as it was easier for users, and it gave the site a more uniform look. 


## Technologies Used

HTML, CSS, RUBY, PostgresSQL, Last.FM API, 
Gems: Sinatra, Active Record, PG, BCrypt, HTTParty, Pry

## Unsolved Problems & Future Features
1. There is currently no filter for duplicate songs. This means that the site could potentially quite messy. 
2. There is no search funtion on the site. As the site grows, it could be difficult to filter through songs you have already listened to. 
3. To avoid potential spamming to the site (and to keep in line with the name of the site) it might be good to limit how many tracks a user can share per week. Being then able to filter by week would be a good way of organising the site. 
