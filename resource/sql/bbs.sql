CREATE DATABASE bbs;

use bbs;

DROP TABLE IF EXISTS `article`;
CREATE TABLE article(
	id INT PRIMARY KEY AUTO_INCREMENT,
	pid INT,
	rootid INT,
	title VARCHAR(255),
	cont TEXT,
	pdate DATETIME,
	isleaf INT COMMENT '0-leaf，1-非leaf'
);

INSERT INTO article VALUES(null, 0, 1, '蚂蚁大战大象', '蚂蚁大战大象', now(), 1);
INSERT INTO article VALUES(null, 1, 1, '大象被打趴下了', '大象被打趴下了', now(), 1);
INSERT INTO article VALUES(null, 2, 1, '蚂蚁也不好过', '蚂蚁也不好过', now(), 0);
INSERT INTO article VALUES(null, 2, 1, '瞎说', '瞎说', now(), 1);
INSERT INTO article VALUES(null, 4, 1, '没有瞎说', '没有说', now(), 0);
INSERT INTO article VALUES(null, 1, 1, '怎么可能', '怎么可能', now(), 1);
INSERT INTO article VALUES(null, 6, 1, '怎么没有可能', '怎么没有可能', now(), 0);
INSERT INTO article VALUES(null, 6, 1, '可能性是很大的', '可能性是很大的', now(), 0);
INSERT INTO article VALUES(null, 2, 1, '大象进医院了', '大象进医院了', now(), 1);
INSERT INTO article VALUES(null, 9, 1, '护士是蚂蚁', '护士是蚂蚁', now(), 0);

select * from article;

/*
树形结构：

蚂蚁大战大象
		大象被打趴下了
				蚂蚁也不好过
				瞎说
						没有瞎说
				大象进医院了
						护士是蚂蚁
		怎么可能
				怎么没有可能
				可能性是很大的

*/