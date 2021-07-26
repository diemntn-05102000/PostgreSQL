-- CREATE DATABASE ch3b1;
-- \c ch3b1
CREATE TABLE Cungcap (
    MSNCC integer NOT NULL,
    MSMH integer NOT NULL,
    Giatien integer
);

CREATE TABLE Mathang (
    MSMH integer NOT NULL,
    TenMH varchar(30),
    Mausac varchar(10)
);

CREATE TABLE NCC (
    MSNCC integer NOT NULL,
    TenNCC varchar(30),
    DiaChi varchar(100)
);


INSERT INTO Cungcap VALUES (1, 1, 150);
INSERT INTO Cungcap VALUES (1, 2, 250);
INSERT INTO Cungcap VALUES (1, 3, 350);
INSERT INTO Cungcap VALUES (1, 4, 50);
INSERT INTO Cungcap VALUES (2, 1, 50);
INSERT INTO Cungcap VALUES (2, 2, 450);
INSERT INTO Cungcap VALUES (2, 3, 250);
INSERT INTO Cungcap VALUES (2, 4, 150);
INSERT INTO Cungcap VALUES (1, 5, 245);

INSERT INTO Mathang VALUES (1, 'Mat hang 1', 'do');
INSERT INTO Mathang VALUES (3, 'Mat hang 3', 'xanh');
INSERT INTO Mathang VALUES (4, 'Mat hang 4', 'do');
INSERT INTO Mathang VALUES (5, 'Mat hang 5', 'do');
INSERT INTO Mathang VALUES (2, 'Mat hang 2', 'tim');

INSERT INTO NCC VALUES (1, 'Cong ty A', 'Dia chi A');
INSERT INTO NCC VALUES (3, 'Cong ty C', 'Dia chi C');
INSERT INTO NCC VALUES (2, 'Dustin', 'Dia chi B');

ALTER TABLE Cungcap
    ADD CONSTRAINT pk_Cungcap PRIMARY KEY (MSNCC, MSMH);

ALTER TABLE Mathang
    ADD CONSTRAINT pk_Mathang PRIMARY KEY (MSMH);
	
ALTER TABLE NCC
    ADD CONSTRAINT pri_key_NCC PRIMARY KEY (MSNCC);

ALTER TABLE Cungcap
    ADD CONSTRAINT fk_Cungcap_Mathang FOREIGN KEY (MSMH) REFERENCES Mathang(MSMH);

ALTER TABLE Cungcap
    ADD CONSTRAINT pk_Cungcap_NCC FOREIGN KEY (MSNCC) REFERENCES NCC(MSNCC);

--1
select distinct NCCC.TenNCC from NCC,Cungcap where NCC.MSNCC = Cungcap.MSNCC and Cungcap.MSMH IN (select Mathang.MSMH from Mathang where Mausac = 'do');

--2
select distinct NCC.TenNCC from NCC,Cungcap where NCC.MSNCC = Cungcap.MSNCC and Cungcap.MSMH IN (select Mathang.MSMH from Mathang where Mausac = 'do' or Mausac = 'xanh');

--3
select distinct NCC.TenNCC from NCC,Cungcap 
where NCC.MSNCC = Cungcap.MSNCC and Cungcap.MSNCC IN (select Cungcap.MSNCC from Cungcap,Mathang where Mausac = 'do' ) 
and Cungcap.MSNCC IN (select Cungcap.MSNCC from Cungcap, Mathang where Mausac = 'xanh' );
    
