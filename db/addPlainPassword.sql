drop procedure if exists schema_change;

delimiter ';;'
create procedure schema_change() begin

    /* delete columns if they exist */
    if exists (select * from information_schema.columns where table_name = 'sessionMember' and column_name = 'plainPassword') then
        alter table sessionMember drop column `plainPassword`;
    end if;
    
    /* add columns */
    alter table sessionMember add column `plainPassword` varchar(255) NULL;

end;;

delimiter ';'
call schema_change();

drop procedure if exists schema_change;