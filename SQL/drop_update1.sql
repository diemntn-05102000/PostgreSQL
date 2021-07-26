select * from store."Order";
select * from store."Product";
delete from store."Product" where "ProductID" = 'LAP001';
update store."Product" set "ProductID" = 'LAP005' where "ProductID" = 'LAP001';
alter table store."Order" drop constraint fk_order_product;
alter table store."Order" add constraint fk_order_product foreign key ("ProductID") references store."Product"("ProductID") 
ON UPDATE CASCADE 
ON DELETE RESTRICT;