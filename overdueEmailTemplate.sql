/*
Created By:				Sean Jones
Creation Date:			8/11/2018
***********************************************************************
Purpose/Comments:		Runs via SQL Agent

***********************************************************************
Versions, Including Latest
***********************************************************************
Updated by:				Sean Jones
Date Updated:			8/11/2018
Version 1.0.0			Initial Release
Notes					Initial Release

***********************************************************************
Return Status:				
***********************************************************************	
*/

create procedure dbo.overdueEmailTemplate
as
begin

	declare @empId int, @maxEmpId int, @maxRow int, 
			@table1Rows nvarchar(max), @table2Rows nvarchar(max), @table3Rows nvarchar(max),
			@table1Len int, @table2Len int, @table3Len int,
			@emailText nvarchar(max), @emailAddress varchar(100)
	
	set @empId = 1
	set @maxEmpId = (select max(id) from [employee list])
	
	
	while (@empId <= @maxEmpId)
	begin
		
		if OBJECT_ID ('dbo.late','U') is not null
			begin
				drop table dbo.late
			end
			
		if @empId in (
			select id
			from [employee list]
		)
		begin
			
			--Set initial HTML templates
			set @table1Rows = N'
				The below <b>[type1]</b> have not been closed yet:
				<br/>
				<br/>
				<table>
					<tr>
						<td bgcolor = #DCDCDC><b>Code</b></td>
						<td bgcolor = #DCDCDC><b>Description</b></td>
						<td bgcolor = #DCDCDC><b>Stage</b></td>
						<td bgcolor = #DCDCDC><b>Date Due</b></td>
						<td bgcolor = #DCDCDC><b>Days passed</b></td>
					</tr>
			'
			
			set @table2Rows = N'
				The below <b>[type2]</b> have not been closed yet:
				<br/>
				<br/>
				<table>
					<tr>
						<td bgcolor = #DCDCDC><b>Code</b></td>
						<td bgcolor = #DCDCDC><b>Description</b></td>
						<td bgcolor = #DCDCDC><b>Stage</b></td>
						<td bgcolor = #DCDCDC><b>Date Due</b></td>
						<td bgcolor = #DCDCDC><b>Days passed</b></td>
					</tr>
			'
			
			set @table3Rows = N'
				The below <b>[type3]</b> have not been closed yet:
				<br/>
				<br/>
				<table>
					<tr>
						<td bgcolor = #DCDCDC><b>Code</b></td>
						<td bgcolor = #DCDCDC><b>Description</b></td>
						<td bgcolor = #DCDCDC><b>Stage</b></td>
						<td bgcolor = #DCDCDC><b>Date Due</b></td>
						<td bgcolor = #DCDCDC><b>Days passed</b></td>
					</tr>
			'
			
			set @table1Len = LEN(@table1Rows) + LEN('</table><br/><br/>')
			set @table2Len = LEN(@table2Rows) + LEN('</table><br/><br/>')
			set @table3Len = LEN(@table3Rows) + LEN('</table><br/><br/>')
			
			--insert employee specific tasks into table below
			select * from dbo.late
			

			--Finsished creating late tasks for first employee
			
			if OBJECT_ID ('dbo.late','U') is not null
			begin
				if (select count(*) from dbo.late) > 0
				begin
					
					alter table dbo.late add id int identity (1,1)
				
					--Insert jobs into HTML script
					set @empId = 1
					set @maxRow = (select max(id) from dbo.late)
					
					while @empId <= @maxRow
					begin
					
						if (select category from dbo.late where id = @empId) = '[type1]'
						begin
						
							set @table1Rows = @table1Rows + N'
								<tr>
									<td>' + cast((select code from dbo.late where id = @empId) as varchar(max)) + '</td>
									<td>' + cast((select name from dbo.late where id = @empId) as varchar(max)) + '</td>
									<td>' + cast((select [status] from dbo.late where id = @empId) as varchar(max)) + '</td>
									<td>' + cast((select datedue from dbo.late where id = @empId) as varchar(max)) + '</td>
									<td' 
									+ 
										(select case when dayspassed between 1 and 7 then ' bgcolor = #FFE465'
													 when dayspassed between 8 and 14 then ' bgcolor = #FFB865'
													 else ' bgcolor = #FF6161'
													 end
										from dbo.late
										where id = @empId) 
									+ 
									'>' + cast((select dayspassed from dbo.late where id = @empId) as varchar(max)) + '</td>
								</tr>
							'
						end	
						
						if (select category from dbo.late where id = @empId) = '[type2]'
						begin
						
							set @table2Rows = @table2Rows + N'
								<tr>
									<td>' + cast((select code from dbo.late where id = @empId) as varchar(max)) + '</td>
									<td>' + cast((select name from dbo.late where id = @empId) as varchar(max)) + '</td>
									<td>' + cast((select [status] from dbo.late where id = @empId) as varchar(max)) + '</td>
									<td>' + cast((select datedue from dbo.late where id = @empId) as varchar(max)) + '</td>
									<td' 
									+ 
										(select case when dayspassed between 1 and 7 then ' bgcolor = #FFE465'
													 when dayspassed between 8 and 14 then ' bgcolor = #FFB865'
													 else ' bgcolor = #FF6161'
													 end
										from dbo.late
										where id = @empId) 
									+ 
									'>' + cast((select dayspassed from dbo.late where id = @empId) as varchar(max)) + '</td>
								</tr>
							'
						end	
						
						if (select category from dbo.late where id = @empId) = '[type3]'
						begin
						
							set @table3Rows = @table3Rows + N'
								<tr>
									<td>' + cast((select code from dbo.late where id = @empId) as varchar(max)) + '</td>
									<td>' + cast((select name from dbo.late where id = @empId) as varchar(max)) + '</td>
									<td>' + cast((select [status] from dbo.late where id = @empId) as varchar(max)) + '</td>
									<td>' + cast((select datedue from dbo.late where id = @empId) as varchar(max)) + '</td>
									<td' 
									+ 
										(select case when dayspassed between 1 and 7 then ' bgcolor = #FFE465'
													 when dayspassed between 8 and 14 then ' bgcolor = #FFB865'
													 else ' bgcolor = #FF6161'
													 end
										from dbo.late
										where id = @empId) 
									+ 
									'>' + cast((select dayspassed from dbo.late where id = @empId) as varchar(max)) + '</td>
								</tr>
							'
						end	
						
					set @empId += 1
						
					end
				end
			end
			
			if (select COUNT(*) from dbo.late) > 0
			begin
				
				--Close table tags
				set @table1Rows = @table1Rows + N'</table><br/><br/>'
				set @table2Rows = @table2Rows + N'</table><br/><br/>'
				set @table3Rows = @table3Rows + N'</table><br/><br/>'
				
				
				--Set HTML body 
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
							Hi ' + (select distinct [name] from dbo.late) + ',
							<br/>
							<br/>
							' + 
							(select case when LEN(@table1Rows) = @table1Len then ''
										 else @table1Rows
									end) 
							+ '' + 
							(select case when LEN(@table2Rows) = @table2Len then ''
										 else @table2Rows
									end) 
							+ '' + 
							(select case when LEN(@table3Rows) = @table3Len then ''
										 else @table3Rows
									end)  
							+ '
						</body>
					</html>
				'

				--set individual email address
				set @emailAddress = [email]
				
				exec msdb.dbo.sp_send_dbmail
					@recipients = '[recipient email]',
					@copy_recipients = '',
					@blind_copy_recipients = '',
					@subject = '[subject]',
					@body = @emailText,
					@profile_name = 'App_Mail_Profile',
					@importance = 'HIGH',
					@body_format = 'HTML',
					@from_address = ''
					
			end
			
		end
	
	set @empId += 1
	end
end
