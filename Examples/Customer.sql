/*-------------------------------------------------------------------*/
/*                                                                   */
/* Table Customer                                                    */
/*                                                                   */
/*----------------*                                                  */
/* R.Ross 08.2016 *                                                  */
/*-------------------------------------------------------------------*/

  create or replace table myapp.customer (
         Id         int           not null default,
         Name       char(25)      not null default,
         Country    char(02)      not null default,
         ZIP        char(05)      not null default,
         City       char(25)      not null default,
         Street     char(30)      not null default,
         Sales      dec(15, 2)    not null default,
         Credit     dec(15, 2)    not null default,
         Balance    dec(15, 2)    not null default,
         Date       date          not null default
  )
         rcdfmt     customerr;

/*-------------------------------------------------------------------*/
/* Primary Key                                                       */
/*-------------------------------------------------------------------*/

  alter table myapp.customer
         add primary key(Id);

/*-------------------------------------------------------------------*/
/* Table Label                                                       */
/*-------------------------------------------------------------------*/

  Label on Table myapp.customer is 'Table Customer';

/*-------------------------------------------------------------------*/ 
