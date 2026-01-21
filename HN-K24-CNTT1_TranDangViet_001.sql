create database thi_cuoi_mon;
use thi_cuoi_mon;

-- Phần 1: 
create table Shippers (
    shipper_id int primary key,
    full_name varchar(100) not null,
    phone varchar(20) not null unique,
    license_type varchar(10) not null,
    rating decimal(2,1) default 5.0 check (rating between 0 and 5)
);

create table Vehicle_Details (
    vehicle_id int primary key,
    shipper_id int,
    license_plate varchar(20) ,
    vehicle_type enum('Tải', 'Xe máy', 'Container'),
    max_payload int check (max_payload > 0),
    foreign key (shipper_id) references Shippers(shipper_id)
);

create table Shipments (
    shipment_id int primary key,
    product_name varchar(255),
    actual_weight decimal(10,2) check (actual_weight > 0),
    product_value decimal(15,2),
    ship_status varchar(20)
);

create table Delivery_Orders (
    order_id int primary key,
    shipment_id int,
    shipper_id int,
    assigned_time datetime default current_timestamp,
    shipping_fee decimal(15,2),
    order_status varchar(20),
    foreign key (shipment_id) references Shipments(shipment_id),
    foreign key (shipper_id) references Shippers(shipper_id)
);

create table Delivery_Log (
    log_id int primary key,
    order_id int,
    current_location varchar(255),
    log_time datetime,
    note varchar(255),
    foreign key (order_id) references Delivery_Orders(order_id)
);

insert into Shippers(shipper_id, full_name,phone, license_type,rating) values
(1, 'Nguyen Van An', 0901234567,'C', 4.8),
(2, 'Tran Thi Binh', 0912345678, 'A2', 5.0),
(3, 'Le Hoang Nam', 0983456789, 'FC', 4.2),
(4, 'Pham Minh Duc', 0354567890, 'B2',4.9),
(5, 'Hoang Quoc Viet',0775678901,'C', 4.7);

insert into Vehicle_Details(vehicle_id, shipper_id, license_plate, vehicle_type, max_payload) values
(101, 1, '29C-123.45','Tải',3500),
(102, 2, '59A-888.88','Xe máy',500),
(103, 3, '15R-999.99','Container',32000),
(104, 4, '30F-111.22','Tải',1500),
(105, 5, '43C-444.55','Tải', 5000);

insert into Shipments(shipment_id, product_name, actual_weight, product_value, ship_status) values
(5001,'Smart TV Samsung 55 inch',25.5,15000000,'In Transit'),
(5002,'Laptop Dell XPS',2.0,35000000,'Delivered'),
(5003,'Máy nén khí công nghiệp',450.0,120000000,'In Transit'),
(5004,'Thùng trái cây nhập khẩu',15.0,2500000,'Returned'),
(5005,'Máy giặt LG Inverter',70.0,9500000,'In Transit');

insert into Delivery_Orders(order_id, shipment_id, shipper_id, assigned_time,shipping_fee,order_status) values
(9001,5001,1,'2024-05-20 08:00:00',2000000,'Processing'),
(9002,5002,2,'2024-05-20 09:30:00',3500000,'Finished'),
(9003,5003,3,'2024-05-20 10:15:00',2500000,'Processing'),
(9004,5004,5,'2024-05-21 07:00:00',1500000,'Finished'),
(9005,5005,4,'2024-05-21 08:45:00',2500000,'Pending');

insert into Delivery_Log(log_id,order_id,current_location,log_time,note) values
(1,9001,'Kho tổng (Hà Nội)','2021-05-15 08:15:00','Rời kho'),
(2,9001,'Trạm thu phí Phủ Lý','2021-05-17 10:00:00','Đang giao'),
(3,9002,'Quận 1, TP.HCM','2024-05-19 10:30:00','Đã đến điểm đích'),
(4,9003,'Cảng Hải Phòng','2024-05-20 11:00:00','Rời kho'),
(5,9004,'Kho hoàn hàng (Đà Nẵng)','2024-05-21 14:00:00','Đã nhập kho trả hàng');

update Delivery_Orders d
join Shipments s on d.shipment_id = s.shipment_id
set d.shipping_fee = d.shipping_fee * 1.1
where d.order_status = 'Finished'
and s.actual_weight > 100;

delete from Delivery_Log where log_time < '2024-05-17';

-- PHẦN 2: Truy vấn dữ liệu cơ bản
-- Câu 1:
select license_plate, vehicle_type, max_payload from Vehicle_Details
where max_payload > 5000 or (vehicle_type = 'Container' and max_payload < 2000);

-- Câu 2:
select full_name, phone from Shippers
where rating between 4.5 and 5.0
and phone like '090%';

-- câu 3:
select * from Shipments order by product_value desc limit 2 offset 2;

-- Phần 3: truy vấn dữ liệu nâng cao
-- Câu 1:
select s.full_name,
sh.shipment_id,
sh.product_name,
d.shipping_fee,
d.assigned_time
from Delivery_Orders d
join Shippers s on d.shipper_id = s.shipper_id
join Shipments sh on d.shipment_id = sh.shipment_id;

-- Câu 2:
select s.full_name,
       SUM(d.shipping_fee) as total_fee
from Delivery_Orders d
join Shippers s on d.shipper_id = s.shipper_id
group by s.shipper_id
having SUM(d.shipping_fee) > 3000000;

-- Câu 3:
select *
from Shippers
where rating = (
    select MAX(rating) from Shippers
);

-- Phần 4:
-- Câu 1:
create index idx_shipment_status_value
on Shipments(ship_status, product_value);


