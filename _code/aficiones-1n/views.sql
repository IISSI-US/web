create or replace view v_user_hobbies AS
SELECT u.user_id, u.full_name, u.email, u.gender, u.age, u.avatar_url, h.hobby_id, h.hobby
FROM users u JOIN user_hobbies h
	ON (u.user_id = h.user_id)
;