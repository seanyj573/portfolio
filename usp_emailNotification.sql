/*
Created By:				Sean Jones
Creation Date:			8/6/2018
***********************************************************************
Purpose/Comments:		Sends quality control email for various jobs
						To use metadata tables to automate an email 
						containing server location, counts and 
						descriptions.
						
***********************************************************************
Versions, Including Latest
***********************************************************************
Updated by:				Sean Jones
Date Updated:			8/6/2018
Version 1.0.0			Initial Release
Notes					Initial Release
***********************************************************************
Updated by:				Sean Jones
Date Updated:			6/7/2018
Version 1.0.1			New email template released
Notes					Extra columns and tables added
***********************************************************************

exec [schema].usp_emailNotification
	@code = 'XXX00000'										--code of current job
	,@complexity = '3'										--complexity rating
	,@folderPath = '\\[Server]\[Drive]\[Main Folder]\[Database]\[Main Folder]\[Client Folder]\[Job Folder]'
	,@jobStage = ''											--use [stage1]/[stage2]/[stage3]/[stage4]
	,@jobType = ''											--use [type1]/[type2]/[type3]
	,@rework = ''											--rework Y/N
	,@firstJob = ''											--first job Y/N
	,@changes = ''											--changes Y/N
	,@specificChanges = ''									--specific changes?
	,@comments = ''											--extra comments

***********************************************************************
Return Status:				
***********************************************************************	
*/

create procedure [schema].[usp_emailNotification]
(@code varchar(25), @complexity varchar(10),
 @folderPath varchar(max), @jobStage varchar(150), @jobType varchar(50), 
 @rework varchar(10), @firstJob varchar(max), @changes varchar(max), @specificChanges varchar(max), @comments varchar(max))

as 
begin

set nocount on

	declare @yourEmail varchar(250), @yourName varchar(250), @subject varchar(max), @database varchar(150), @Client varchar(150), @server varchar(50), 
			@sTable1 varchar(250), @sTable2 varchar(250), @sTable3 varchar(250), @sTable4 varchar(250),
			@mSTable1 varchar(250), @mSTable2 varchar(250), @mSTable3 varchar(250), @mSTable4 varchar(250),
			@table1 varchar(250), @table2 varchar(250), @table3 varchar(250), @table4 varchar(250),
			@mTable1 varchar(250), @mTable2 varchar(250), @mTable3 varchar(250), @mTable4 varchar(250),
			@dueDate date, @dynSQL nvarchar(max),
			@selectionTable varchar(200), @houseTable varchar(200),
			@error int
	
	
	--error checking   
	set @error = case
					 when @code not like '[a-z][a-z][a-z][0-9][0-9][0-9][0-9][0-9]' then 1
					 when @complexity not in ('1','2','3','4','5') then 2
					 when @folderPath like '%\secure%' then 3
					 when @jobStage not in ('[stage1]','[stage2]','[stage3]','[stage4]') then 4
					 when @jobType not in ('[type1]','[type2]','[type3]') then 5
					 when @jobStage not in ('[stage4]') and @jobType in ('[type3]') then 6
					 when @jobStage in ('[stage1]') and @jobType in ('[type2]') then 7
					 when @jobStage in ('[stage2]') and @jobType not in ('[type1]') then 8
					 else 0 
				 end
				 
	if @error > 0 goto ERRORCHECK 			 
	
	if (@jobType = '[type3]')
	begin
		set @jobStage = '[type3]'
	end
	
	create table #sp_who (
		spid int,
		ecid int,
		[status] varchar(250),
		loginame varchar(250),
		hostname varchar(250),
		blk int,
		dbname varchar(250),
		cmd varchar(250),
		requestid int
	)
	insert into #sp_who
	exec sp_who

	set @yourName = (select replace(substring(loginame, patindex('%\%', loginame)+1, len(loginame)),'.',' ') from #sp_who)
	set @yourEmail = (select substring(loginame, patindex('%\%', loginame)+1, len(loginame))+'[domain name]' from #sp_who)
	set @database = (select dbname from #sp_who)
	set @client = (select [client] from [client table] where [client name] = (select left(dbname,3) from #sp_who))
	set @server = (select [value] from [MetaData] where [type] = '[server]')
	
	set @subject = (select substring( substring(@folderPath ,patindex('%[Job Folder]%',@folderPath)+12,len(@folderPath)),
							patindex('%\%',substring(@folderPath ,patindex('%[Job Folder]%',@folderPath)+12,len(@folderPath)))+1,
							 len(substring(@folderPath ,patindex('%[Job Folder]%',@folderPath)+12,len(@folderPath)))
					) + ' - ' + @jobStage)
	
	--set comments to null if blank
	if (@rework = '')
	begin
		set @rework = null
	end
	if (@firstJob = '')
	begin
		set @firstJob = null
	end
	if (@changes = '')
	begin
		set @changes = null
	end
	if (@specificChanges = '')
	begin
		set @specificChanges = null
	end
	if (@comments = '')
	begin
		set @comments = null
	end
	
	--set selection table
	if (@jobStage in ('[stage1]','[stage3]','[stage4]'))
	begin
		set @selectionTable = '[schema].'+@code+'[table name]'
	end
	
	--set house table if needed
	if exists (select name from sys.tables where name like '%'+@code+'%[table name]%')
	begin
		set @houseTable = (select [value] from [MetaData] where [type] = '[database]') + '[tabel name]'
	end


	if (@jobStage = '[stage1]')
	begin 
		set @dueDate = (select dateadd(day,-1,dateStep1Required)
						from [date list] a
						inner join [client list] b
						on a.id = b.id
						where a.code = cast(cast(substring(@code,4,len(@code)) as integer) as varchar)
						and b.client = left(@code,3)
						)
	end

	if (@jobStage = '[stage3]')
	begin 
		set @dueDate = (select dateStep2Required
						from [job list] a
						inner join [client list] b
						on a.id = b.id
						where a.code = cast(cast(substring(@code,4,len(@code)) as integer) as varchar)
						and b.client = left(@code,3)
						)
	end

	if (@jobStage in ('[stage4]','[type3]'))
	begin 
		set @dueDate = (select dateAgreed
						from [job list] a
						inner join [client list] b
						on a.id = b.id
						where a.code = cast(cast(substring(@code,4,len(@code)) as integer) as varchar)
						and b.client = left(@code,3)
						)
	end

	if (@jobStage in ('[stage2]'))
	begin
		set @dueDate = CAST(GETDATE() as date)
	end
	
	
	--due date error check 
	set @error = case
					 when @dueDate is null then 9
					 else 0 
				 end
				 
	if @error > 0 goto ERRORCHECK
	
	
	--set s tables and counts only for [type1]
	if(@jobType in ('[type1]') and @jobStage in ('[stage1]','[stage3]'))
	begin
		--Set s table names
		set @dynSQL = '
			if (exists (select name 
						from sys.tables 
						where name like ''%' + @code + '%[table name]''
						)
				)
			begin
				set @sTable1 = ''[[schema]].[' + @code + '_[table name]]'' 
			end
		'
		exec sp_executesql @dynSQL, N'@sTable1 varchar(250) out', @sTable1 out
		set @dynSQL = '
			if (exists (select a.name 
						from sys.tables a
						inner join sys.schemas b
						on a.schema_id = b.schema_id
						where a.name like ''%[table name]''
						and b.name = ''[schema]''
						)
				)
			begin
				set @mSTable1 = ''[[schema]].[[table name]]'' 
			end
		'
		exec sp_executesql @dynSQL, N'@mSTable1 varchar(250) out', @mSTable1 out

		set @dynSQL = '
			if (exists (select name 
						from sys.tables 
						where name like ''%' + @code + '%[table name]''
						)
				)
			begin
				set @sTable2 = ''[[schema]].[' + @code + '[table name]]'' 
			end
		'
		exec sp_executesql @dynSQL, N'@sTable2 varchar(250) out', @sTable2 out
		set @dynSQL = '
			if (exists (select a.name 
						from sys.tables a
						inner join sys.schemas b
						on a.schema_id = b.schema_id
						where a.name like ''%[table name]''
						and b.name = ''[schema]''
						)
				)
			begin
				set @mSTable2 = ''[[schema]].[[table name]]'' 
			end
		'
		exec sp_executesql @dynSQL, N'@mSTable2 varchar(250) out', @mSTable2 out
		
		set @dynSQL = '
			if (exists (select name 
						from sys.tables 
						where name like ''%' + @code + '%[table name]''
						)
				)
			begin
				set @sTable3 = ''[[schema]].[' + @code + '[table name]]'' 
			end
		'
		exec sp_executesql @dynSQL, N'@sTable3 varchar(250) out', @sTable3 out
		set @dynSQL = '
			if (exists (select a.name 
						from sys.tables a
						inner join sys.schemas b
						on a.schema_id = b.schema_id
						where a.name like ''%[table name]''
						and b.name = ''[schema]''
						)
				)
			begin
				set @mSTable3 = ''[[schema]].[[table name]]'' 
			end
		'
		exec sp_executesql @dynSQL, N'@mSTable3 varchar(250) out', @mSTable3 out
		
		set @dynSQL = '
			if (exists (select name 
						from sys.tables 
						where name like ''%' + @code + '%[table name]''
						)
				)
			begin
				set @sTable4 = ''[[schema]].[' + @code + '[table name]]'' 
			end
		'
		exec sp_executesql @dynSQL, N'@sTable4 varchar(250) out', @sTable4 out
		set @dynSQL = '
			if (exists (select a.name 
						from sys.tables a
						inner join sys.schemas b
						on a.schema_id = b.schema_id
						where a.name like ''%[table name]''
						and b.name = ''[schema]''
						)
				)
			begin
				set @mSTable4 = ''[[schema]].[[table name]]'' 
			end
		'
		exec sp_executesql @dynSQL, N'@mSTable4 varchar(250) out', @mSTable4 out


		--Set s counts
		--1
		if (exists (select * 
					from information_schema.tables
					where table_schema = '[schema]' 
					and table_name = '[table name]'
					)
			)
		begin
			drop table [schema].[table name]
		end
		if (@sTable1 is not null)
		begin
			set @dynSQL = '
				select count(*) as counts
				into [schema].[table name]
				from ' + @sTable1 + '
			'
			exec sp_executesql @dynSQL

			set @table1 = '--' + cast((select * from [schema].[table name]) as varchar)

		end
		
		if (exists (select * 
					from information_schema.tables
					where table_schema = '[schema]' 
					and table_name = '[table name]'
					)
			)
		begin
			drop table [schema].[table name]
		end
		if (@mSTable1 is not null)
		begin
			set @dynSQL = '
				select count(*) as counts
				into [schema].[table name]
				from ' + @mSTable1 + '
				where code = ''' + @code + '''
			'
			exec sp_executesql @dynSQL

			set @mTable1 = '--' + cast((select * from [schema].[table name]) as varchar)

		end

		--2
		if (exists (select * 
					from information_schema.tables
					where table_schema = '[schema]' 
					and table_name = '[table name]'
					)
			)
		begin
			drop table [schema].[table name]
		end
		if (@sTable2 is not null)
		begin
			set @dynSQL = '
				select count(*) as counts
				into [schema].[table name]
				from ' + @sTable2 + '
			'
			exec sp_executesql @dynSQL

			set @table2 = '--' + cast((select * from [schema].[table name]) as varchar)

		end
		
		if (exists (select * 
					from information_schema.tables
					where table_schema = '[schema]' 
					and table_name = '[table name]'
					)
			)
		begin
			drop table [schema].[table name]
		end
		if (@mSTable2 is not null)
		begin
			set @dynSQL = '
				select count(*) as counts
				into [schema].[table name]
				from ' + @mSTable2 + '
				where code = ''' + @code + '''
			'
			exec sp_executesql @dynSQL

			set @mTable2 = '--' + cast((select * from [schema].[table name]) as varchar)

		end
		
		--3
		if (exists (select * 
					from information_schema.tables
					where table_schema = '[schema]' 
					and table_name = '[table name]'
					)
			)
		begin
			drop table [schema].[table name]
		end
		if (@sTable3 is not null)
		begin
			set @dynSQL = '
				select count(*) as counts
				into [schema].[table name]
				from ' + @sTable3 + '
			'
			exec sp_executesql @dynSQL

			set @table3 = '--' + cast((select * from [schema].[table name]) as varchar)
		end

		if (exists (select * 
					from information_schema.tables
					where table_schema = '[schema]' 
					and table_name = '[table name]'
					)
			)
		begin
			drop table [schema].[table name]
		end
		if (@mSTable3 is not null)
		begin
			set @dynSQL = '
				select count(*) as counts
				into [schema].[table name]
				from ' + @mSTable3 + '
				where code = ''' + @code + '''
			'
			exec sp_executesql @dynSQL

			set @mTable3 = '--' + cast((select * from [schema].[table name]) as varchar)

		end
		
		--4
		if (exists (select * 
					from information_schema.tables
					where table_schema = '[schema]' 
					and table_name = '[table name]'
					)
			)
		begin
			drop table [schema].[table name]
		end

		if (@sTable4 is not null)
		begin
			set @dynSQL = '
				select count(*) as counts
				into [schema].[table name]
				from ' + @sTable4 + '
			'
			exec sp_executesql @dynSQL

			set @table4 = '--' + cast((select * from [schema].[table name]) as varchar)
		end

		if (exists (select * 
					from information_schema.tables
					where table_schema = '[schema]' 
					and table_name = '[table name]'
					)
			)
		begin
			drop table [schema].[table name]
		end
		if (@mSTable4 is not null)
		begin
			set @dynSQL = '
				select count(*) as counts
				into [schema].[table name]
				from ' + @mSTable4 + '
				where code = ''' + @code + '''
			'
			exec sp_executesql @dynSQL

			set @mTable4 = '--' + cast((select * from [schema].[table name]) as varchar)

		end
		
		--drop table after use
		if (exists (select * 
					from information_schema.tables
					where table_schema = '[schema]' 
					and table_name = '[table name]'
					)
			)
		begin
			drop table [schema].[table name]
		end


		--if table counts are null
		if (@sTable1 is null)
		begin
			set @table1 = '--table1 unavailable'
		end
		if (@mSTable1 is null)
		begin
			set @mTable1 = '--ma s table1 unavailable'
		end
		if (@sTable2 is null)
		begin
			set @table2 = '--table2 unavailable'
		end
		if (@mSTable2 is null)
		begin
			set @mTable2 = '--m s table2 unavailable'
		end
		if (@sTable3 is null)
		begin
			set @table3 = '--table3 unavailable'
		end
		if (@mSTable3 is null)
		begin
			set @mTable3 = '--m s table3 unavailable'
		end
		if (@sTable4 is null)
		begin
			set @table4 = '--table4 unavailable'
		end
		if (@mSTable4 is null)
		begin
			set @mTable4 = '--m s table4 unavailable'
		end
	end
	else 
	begin
		set @sTable1 = ''
		set @mSTable1 = ''
		set @sTable2 = ''
		set @mSTable2 = ''
		set @sTable3 = ''
		set @mSTable3 = ''
		set @sTable4 = ''
		set @mSTable4 = ''
		set	@table1 = ''
		set	@mTable1 = ''
		set @table2 = ''
		set @mTable2 = ''
		set @table3 = ''
		set @mTable3 = ''
		set @table4 = ''
		set @mTable4 = ''
	end
	
	
	--SET EMAIL BODY    
	declare @emailText nvarchar(MAX)      
	set @emailText = N'
		<style>
		body {
			font-family: Calibri;
			font-size: 14;
		}	
		
		td {
			border: 1px solid black;
			padding-top: 3px;
			padding-right: 5px;
			padding-bottom: 3px;
			padding-left: 5px;
		}
		
		td.padOut {
			padding-right: 20px;
		}
		
		td.noBorder {
			border-left: 0px;
			border-right: 0px;
		}
		
		td.noLeftBorder {
			border-left: 0px;
			padding-left: 25px;
			padding-right: 20px;
		}
		
		table {
			border-collapse: collapse;
		}
		
		</style>
		
		<html lang = "en">
			<body>
				Hi,
				<br/>
				<br/>[Insert opening line text]:
				<br/>
				<br/>
				<table>
					<tr>
						<td bgcolor = #B0E0E6><b>Required By Date</b></td>
						<td class = "padOut" colspan = "2"; style = "color: red; font-size: 25px"><b>' + cast(day(isnull(@dueDate,' ')) as varchar) + '/' 
																									   + cast(month(isnull(@dueDate,' ')) as varchar) + '/' 
																									   + cast(year(isnull(@dueDate,' ')) as varchar) + '</b></td>
					</tr>
					<tr>
						<td bgcolor = #B0E0E6><b>Client</b></td>
						<td class = "padOut" colspan = "2">' + isnull(@client,' ') + '</td>
					</tr>
					<tr>
						<td bgcolor = #B0E0E6><b>Server</b></td>
						<td class = "padOut" colspan = "2">' + isnull(@server,' ') + '</td>
					</tr>
					<tr>
						<td bgcolor = #B0E0E6><b>Database</b></td>
						<td class = "padOut" colspan = "2">' + isnull(@database,' ') + '</td>
					</tr>
					<tr>
						<td bgcolor = #B0E0E6><b>Code</b></td>
						<td class = "padOut" colspan = "2"><b>' + isnull(@code,' ') + '</b></td>
					</tr>
					<tr>
						<td bgcolor = #B0E0E6><b>Complexity Level</b></td>
						<td class = "padOut" colspan = "2">' + isnull(@complexity,' ') + '</td>
					</tr>
					<tr>
						<td bgcolor = #B0E0E6><b>Job Type</b></td>
						<td class = "padOut" colspan = "2">' + isnull(@jobType,' ') + '</td>
					</tr>
					<tr>
						<td bgcolor = #B0E0E6><b>Selection Table</b></td>
						<td class = "padOut" colspan = "2"><font face = "Courier New">' + isnull(@selectionTable,'') + '</font></td>
					</tr>
					<tr>
						<td bgcolor = #B0E0E6><b>S Table(s)</b></td>
						<td class = "noBorder">
							<font face = "Courier New">
								' + isnull(@sTable1,'[...]') + ' <br/>
								' + isnull(@mSTable1,'[...]') + ' <br/>
								' + isnull(@sTable2,'[...]') + ' <br/>
								' + isnull(@mSTable2,'[...]') + ' <br/>
								' + isnull(@sTable3,'[...]') + ' <br/>
								' + isnull(@mSTable3,'[...]') + ' <br/>
								' + isnull(@sTable4,'[...]') + ' <br/>
								' + isnull(@mSTable4,'[...]') + ' 
							</font>
						</td>
						<td class = "noLeftBorder" width = "300">
							<font face = "Courier New" style = "color: green">
								' + isnull(@table1,'--0') + ' <br/> 
								' + isnull(@mTable1,'--0') + ' <br/> 
								' + isnull(@table2,'--0') + ' <br/> 
								' + isnull(@mTable2,'--0') + ' <br/> 
								' + isnull(@table3,'--0') + ' <br/> 
								' + isnull(@mTable3,'--0') + ' <br/> 
								' + isnull(@table4,'--0') + ' <br/> 
								' + isnull(@mTable4,'--0') + '
							</font>
						</td>
					</tr>
					<tr>
						<td bgcolor = #B0E0E6><b>House Table</b></td>
						<td class = "padOut" colspan = "2">' + isnull(@houseTable,' ') + '</td>
					</tr>
					<tr>
						<td bgcolor = #B0E0E6><b>Job Folder Path</b></td>
						<td class = "padOut" colspan = "2"><a href = "' + isnull(@folderPath,' ') + '"> ' + isnull(@folderPath,' ') + ' </a></td>
					</tr>
					<tr>
						<td bgcolor = #B0E0E6><b>Comments/Details</b></td>
						<td class = "padOut" colspan = "2">
						<b><u>Is this counts/[stage2]/[stage4]?</u></b><br/>
						<font color = "red">' + isnull(@jobStage,' ') + ' </font><br/> 
						<b><u>Is this a re-work?</u></b><br/>
						<font color = "red">' + isnull(@rework,'No') + ' </font><br/> 
						<b><u>Are there any universe changes?</u></b><br/>
						<font color = "red">' + isnull(@changes,'No') + ' </font><br/> 
						<b><u>Are there any job specific changes?</u></b><br/>
						<font color = "red">' + isnull(@specificChanges,'No') + ' </font><br/> 
						<b><u>Other?</u></b><br/>
						<font color = "red">' + isnull(@comments,'No') + ' </font><br/> 
						</td>
					</tr>
				</table>
				<br/>Thanks,
				<br/>
				<br/>
 				<font face = "Century Gothic" size = "2.5">
 					' + @yourName + '
 					<br/><img src = "[image link]>
 					<br/>
 					<br/>[signature line 1]
 					<br/>[signature line 2]
 					<br/>[signature line 3]
 					<br/><a href = "[insert website]" style = "color: #00B0F0"><u>[website]<b>2</b>[domain]</u></a>
 					<br/>
 					<br/><font face = "WebDings" size = "4" style = "color: #008000">P</font><font face = "Arial" size = "1" style = "color: #008000">    <b>Help save paper - do you need to print this email?</b></font>
 				</font>
			</body>    
		</html>          
	'      
	
	    
	--SEND EMAIL    
	exec msdb.dbo.sp_send_dbmail                                                         
		@recipients = '[recipient email]',
		@copy_recipients = '[copy recipient email]',
		@blind_copy_recipients = '',
		@subject = @subject,
		@body = @emailText,
		@profile_name = '[mail profile]',
		@importance = 'NORMAL',
		@body_format = 'HTML',
		@from_address = @yourEmail
	
	
	--errors    
	ERRORCHECK:
	if @error > 0 
	begin    
		select 'Procedure usp_emailNotification has failed' as ERROR,
		case @error
			when 1 then '@code parameter set incorrectly'
			when 2 then '@complexity parameter must be an integer between 1 and 5'
			when 3 then '@folderPath must be in the format: \\[Server]\[Drive]\[Main Folder]\[Database]\[Main Folder]\[Client Folder]\[Job Folder]'
			when 4 then '@jobStage must be one of the following: [stage1] | [stage3] | [stage4]'
			when 5 then '@jobType must be one of the following: [type 1] | [type 2] | [type 3]'
			when 6 then '@jobStage must be [stage4] when @jobType is [type 3]'
			when 7 then '@jobStage can only be [stage1] when @jobType is [type 1]'
			when 8 then '@jobType must be [type 1] when @jobStage is [stage2]'
			when 9 then '@dueDate is null as job specified does not exist'
			else 'Unknown error'
		end as ErrorMessage    
	end   
	
end
