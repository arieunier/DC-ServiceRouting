drop table if exists public.RemoteCompute;
create table public.RemoteCompute(
        JobId varchar(255) not null primary key,
        CreationDate timestamp not null default NOW(),  
        CreatedById varchar(255) not null, 
        ContextRecordId__c varchar(255),
        ComputeService__c varchar(255),
        ComputeAttributes__c varchar(255), 
        RawData varchar(8000) not null);
drop table if exists public.RemoteComputeStep;
create table public.RemoteComputeStep(
            id varchar(255) not null primary key, 
            refJobId varchar(255) not null , 
            CreationDate varchar(255) not null default NOW(), 
            ServiceName varchar(255) not null,
            CurrentText varchar(255), 
            RawData varchar(8000)) ;

-- table for micro service defition
drop table if exists public.ServiceDefinition;
create table public.ServiceDefinition(
        id varchar(255) not null primary key,
        ServiceName varchar(255) not null , 
        ServiceLabel varchar(255) not null , 
        ServiceDescription varchar(1024) not null 
);
drop table if exists public.ServiceAttribute;
create table public.ServiceAttribute(
        id varchar(255) not null primary key,
        refServiceDefinitionId varchar(255) not null ,
        AttributeName varchar(255) not null , 
        AttributeLabel varchar(255) not null , 
        AttributeDescription varchar(1024) not null,
        AttributeAllowedValues varchar(1024)
);

insert into public.ServiceDefinition(id, ServiceName, ServiceLabel, ServiceDescription) values ('1','accountscreation','Mass Account Creation', 'Creates a large number of accounts.');
insert into public.ServiceAttribute(id, refServiceDefinitionId, AttributeName, AttributeLabel, AttributeDescription) values ('1','1',' AccountQuantity  ','Number of accounts', 'Number of accounts to create. Please enter a positive number');
insert into public.ServiceAttribute(id, refServiceDefinitionId, AttributeName, AttributeLabel, AttributeDescription) values ('2','1',' NamePattern  ','Account name pattern', 'Pattern to use to generate the name of the account. Please enter a string');
insert into public.ServiceAttribute(id, refServiceDefinitionId, AttributeName, AttributeLabel, AttributeDescription, AttributeAllowedValues) values ('3','1',' RandomAttribute  ','Random Attribute', 'To test allowed values', 'Test,ABCD,QSD');
