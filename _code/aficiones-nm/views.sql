create or replace view v_user_hobbies AS
SELECT u.user_id, u.full_name, u.email, u.gender, u.age, u.avatar_url, 
       uhl.user_hobby_id, h.hobby_id, h.hobby_name
FROM users u JOIN user_hobby_links uhl
	ON (u.user_id = uhl.user_id) JOIN hobbies h
	ON (uhl.hobby_id = h.hobby_id)
;