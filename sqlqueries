select t.name, g.name from track as t join genre as g on t.genre_id = g.genre_id;

select * from customer where country = 'USA';

select first_name, last_name, email from customer;

select artist_id from artist where name = 'Audioslave';

select al.title, ar.name from album as al join artist as ar on al.artist_id = ar.artist_id where al.artist_id = (select artist_id from artist where name = 'Audioslave');

select g.name, count(*) from track as t join genre as g on t.genre_id = g.genre_id group by g.name;

select * from invoice where total > 10;

select genre_id, max(totalTracks) from ( select genre_id, count(*) as totalTracks from track group by genre_id) group by genre_id;

select invoice_id, max(total) from invoice group by invoice_id;

select genre_id, max(totalTracks) from ( select genre_id, count(*) as totalTracks from track group by genre_id) group by genre_id LIMIT 1;

select t.name, g.genre_id, g.maximumTrack from genre as t join (select genre_id, name, max(totalTracks) as maximumTrack from ( select genre_id, name, count(*) as totalTracks from track group by genre_id, name) group by genre_id, name) as g on t.genre_id = g.genre_id;

select totalTrk.genre_id, g.name, totalTrk.maximumtrack from (select genre_id, max(totalTracks) as maximumTrack from ( select genre_id, count(*) as totalTracks from track group by genre_id) group by genre_id) as totalTrk join genre as g on totalTrk.genre_id = g.genre_id Limit 1;

select billing_country, sum(total) from invoice group by billing_country order by sum(total) desc;

select i.customer_id, c.first_name, c.last_name, sum(total) as amountSpent from invoice as i join customer as c on i.customer_id = c.customer_id group by i.customer_id, c.first_name, c.last_name order by sum(total) desc limit 5;

select i.billing_country, count(il.quantity) from invoice_line as il join invoice as i on i.invoice_id = il.invoice_id group by i.billing_country order by count(il.quantity) desc;

select pl.playlist_id, pl.name, count(pt.playlist_id) from playlist_track as pt join playlist as pl on pt.playlist_id = pt.playlist_id group by pl.playlist_id, pl.name having count(pt.playlist_id) > 50;

select at.name, count(*) from track as t join album as al on t.album_id = al.album_id join artist as at on al.artist_id = at.artist_id group by at.name order by count(*) desc limit 1;

