-- CREATE DATABASE ch3b4;
-- \c ch3b4

CREATE TABLE sinhvien( -- ko nên viết tắt quá ko hiểu ý nghĩa từng bảng
	mssv char(8) not null,
	hoten varchar(30) not null,
	ngaysinh date ,
	quequan varchar(30)
	);

CREATE TABLE monhoc(
	msmh char(8) not null,
	tenmh varchar(20) not null,
	tengv varchar(30) not null
	);

CREATE TABLE dangky(
	msmh char(8) not null,
	mssv char(8) not null,
	diem float not null
	);

ALTER TABLE sinhvien ADD CONSTRAINT pk_sv PRIMARY KEY (mssv);

ALTER TABLE monhoc ADD CONSTRAINT pk_mh PRIMARY KEY (msmh);

ALTER TABLE dangky ADD CONSTRAINT pk_dk PRIMARY KEY (msmh, mssv);

ALTER TABLE dangky ADD CONSTRAINT fk_2sv FOREIGN KEY (mssv) REFERENCES sinhvien(mssv);

ALTER TABLE dangky ADD CONSTRAINT fk_2mh FOREIGN KEY (msmh) REFERENCES monhoc(msmh);

ALTER TABLE dangky ADD CONSTRAINT ck_diem CHECK (diem>=0 and diem <= 10);

-- Thông thường các rằng buộc nên tạo trước khi insert dữ liệu vào để đảm bảo dữ liệu ko bị insert sai

INSERT INTO sinhvien VALUES ('20142014', 'Le Van Long', date '1996-01-10', 'nam dinh');
INSERT INTO sinhvien VALUES ('20142017', 'Tran Tuan Minh', date '1996-04-06', 'ha tay');
INSERT INTO sinhvien VALUES ('20142012', 'Nguyen Van Minh', date '1995-09-10', 'bac giang');
INSERT INTO sinhvien VALUES ('20142015', 'Tran Van Tuan', date '1996-01-03', 'ca mau');
INSERT INTO sinhvien VALUES ('20152016', 'Nguyen Anh Quan', date '1997-04-10', 'quang ninh');
INSERT INTO sinhvien VALUES ('20042325', 'Nguyen Thuy Linh', date '1990-02-07', 'da nang');

INSERT INTO monhoc VALUES ('m1', 'csdl', 'Le Quan');
INSERT INTO monhoc VALUES ('m2', 'csdl', 'Nguyen Thi Oanh');
INSERT INTO monhoc VALUES ('m3', 'giaitich', 'Nguyen Duy Thanh');
INSERT INTO monhoc VALUES ('m4', 'vldc', 'Cao Ba Quat');
INSERT INTO monhoc VALUES ('m5', 'ctdlgt', 'Nguyen Duc Nghia');
INSERT INTO monhoc VALUES ('m6', 'oop', 'Trinh Thanh Trung');
INSERT INTO monhoc VALUES ('m7', 'ktlt', 'Vu Duc Vuong');
INSERT INTO monhoc VALUES ('m8', 'cnpm', 'Vu Thi Huong Giang');

INSERT INTO dangky VALUES ('m1', '20142012', 8);
INSERT INTO dangky VALUES ('m1', '20142014', 9);
INSERT INTO dangky VALUES ('m1', '20142015', 8);
INSERT INTO dangky VALUES ('m2', '20142017', 5);
INSERT INTO dangky VALUES ('m2', '20142012', 4);
INSERT INTO dangky VALUES ('m2', '20142014', 10);
INSERT INTO dangky VALUES ('m2', '20042325', 6);
INSERT INTO dangky VALUES ('m3', '20042325', 8);
INSERT INTO dangky VALUES ('m3', '20142015', 3);
INSERT INTO dangky VALUES ('m4', '20142012', 7);
INSERT INTO dangky VALUES ('m4', '20142017', 9);
INSERT INTO dangky VALUES ('m5', '20042325', 8);
INSERT INTO dangky VALUES ('m5', '20152016', 10);
INSERT INTO dangky VALUES ('m6', '20142012', 10);
INSERT INTO dangky VALUES ('m7', '20142014', 6);
INSERT INTO dangky VALUES ('m7', '20142012', 2);
