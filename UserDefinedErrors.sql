USE kms

-- ������ ��������� dbo.AddPerson
EXEC sp_dropmessage 60001, @lang='russian'
EXEC sp_dropmessage 60001, @lang='us_english'
EXEC sp_addmessage 60001, 16,
	N'dbo.AddPerson: wrong @fam for adding!', @lang='us_english'
EXEC sp_addmessage 60001, 16,
	N'dbo.AddPerson: ������������ ��� ���������� �������� ��������� @scn!', @lang='russian'

EXEC sp_dropmessage 60002, @lang='russian'
EXEC sp_dropmessage 60002, @lang='us_english'
EXEC sp_addmessage 60002, 16,
	N'dbo.AddPerson: empty @fam prohibited!', @lang='us_english'
EXEC sp_addmessage 60002, 16,
	N'dbo.AddPerson: ������ ���� fam!', @lang='russian'

EXEC sp_dropmessage 60003, @lang='russian'
EXEC sp_dropmessage 60003, @lang='us_english'
EXEC sp_addmessage 60003, 16,
	N'dbo.AddPerson: empty @im prohibited!', @lang='us_english'
EXEC sp_addmessage 60003, 16,
	N'dbo.AddPerson: ������ ���� im!', @lang='russian'

EXEC sp_dropmessage 60004, @lang='russian'
EXEC sp_dropmessage 60004, @lang='us_english'
EXEC sp_addmessage 60004, 16,
	N'dbo.AddPerson: empty @ot prohibited!', @lang='us_english'
EXEC sp_addmessage 60004, 16,
	N'dbo.AddPerson: ������ ���� ot ��� d_fam!="1"!', @lang='russian'

EXEC sp_dropmessage 60005, @lang='russian'
EXEC sp_dropmessage 60005, @lang='us_english'
EXEC sp_addmessage 60005, 16,
	N'dbo.AddPerson: empty @dr prohibited!', @lang='us_english'
EXEC sp_addmessage 60005, 16,
	N'dbo.AddPerson: ������ ���� dr!', @lang='russian'

EXEC sp_dropmessage 60006, @lang='russian'
EXEC sp_dropmessage 60006, @lang='us_english'
EXEC sp_addmessage 60006, 16,
	N'dbo.AddPerson: empty @w prohibited!', @lang='us_english'
EXEC sp_addmessage 60006, 16,
	N'dbo.AddPerson: ������ ���� w!', @lang='russian'
-- ������ ��������� dbo.AddPerson

-- ������ ��������� dbo.UpdatePerson
EXEC sp_dropmessage 60010, @lang='russian'
EXEC sp_dropmessage 60010, @lang='us_english'
EXEC sp_addmessage 60010, 16,
	N'dbo.UpdatePerson: empty @recid!', @lang='us_english'
EXEC sp_addmessage 60010, 16,
	N'dbo.UpdatePerson: ����� ��������� � ������ recid!', @lang='russian'

EXEC sp_dropmessage 60011, @lang='russian'
EXEC sp_dropmessage 60011, @lang='us_english'
EXEC sp_addmessage 60011, 16,
	N'dbo.UpdatePerson: incorrect @recid!', @lang='us_english'
EXEC sp_addmessage 60011, 16,
	N'dbo.UpdatePerson: ����� ��������� � �������������� recid!', @lang='russian'

EXEC sp_dropmessage 60012, @lang='russian'
EXEC sp_dropmessage 60012, @lang='us_english'
EXEC sp_addmessage 60012, 16,
	N'dbo.UpdatePerson: incorrect @scn', @lang='us_english'
EXEC sp_addmessage 60012, 16,
	N'dbo.UpdatePerson: ����� ��������� � ������������ ��� Update recid!', @lang='russian'

EXEC sp_dropmessage 60020, @lang='russian'
EXEC sp_dropmessage 60020, @lang='us_english'
EXEC sp_addmessage 60020, 16,
	N'dbo.UpdatePerson: documents (@s_doc+@n_doc) already exists!', @lang='us_english'
EXEC sp_addmessage 60020, 16,
	N'dbo.UpdatePerson: ������ ��������� ���������!', @lang='russian'

EXEC sp_dropmessage 60021, @lang='russian'
EXEC sp_dropmessage 60021, @lang='us_english'
EXEC sp_addmessage 60021, 16,
	N'dbo.UpdatePerson: documents (@s_doc+@n_doc) already exists!', @lang='us_english'
EXEC sp_addmessage 60021, 16,
	N'dbo.UpdatePerson: ������ ������� ���������!', @lang='russian'

EXEC sp_dropmessage 60022, @lang='russian'
EXEC sp_dropmessage 60022, @lang='us_english'
EXEC sp_addmessage 60022, 16,
	N'dbo.UpdatePerson: documents (@s_doc+@n_doc) already exists!', @lang='us_english'
EXEC sp_addmessage 60022, 16,
	N'dbo.UpdatePerson: ������ ���������� �� ����������!', @lang='russian'

EXEC sp_dropmessage 60023, @lang='russian'
EXEC sp_dropmessage 60023, @lang='us_english'
EXEC sp_addmessage 60023, 16,
	N'dbo.UpdatePerson: documents (@s_doc+@n_doc) already exists!', @lang='us_english'
EXEC sp_addmessage 60023, 16,
	N'dbo.UpdatePerson: ������ ��!', @lang='russian'

EXEC sp_dropmessage 60024, @lang='russian'
EXEC sp_dropmessage 60024, @lang='us_english'
EXEC sp_addmessage 60024, 16,
	N'dbo.UpdatePerson: documents (@s_doc+@n_doc) already exists!', @lang='us_english'
EXEC sp_addmessage 60024, 16,
	N'dbo.UpdatePerson: ������ ���!', @lang='russian'

EXEC sp_dropmessage 60025, @lang='russian'
EXEC sp_dropmessage 60025, @lang='us_english'
EXEC sp_addmessage 60025, 16,
	N'dbo.UpdatePerson: documents (@s_doc+@n_doc) already exists!', @lang='us_english'
EXEC sp_addmessage 60025, 16,
	N'dbo.UpdatePerson: ������ ������� ���!', @lang='russian'

EXEC sp_dropmessage 60026, @lang='russian'
EXEC sp_dropmessage 60026, @lang='us_english'
EXEC sp_addmessage 60026, 16,
	N'dbo.UpdatePerson: documents (@s_doc+@n_doc) already exists!', @lang='us_english'
EXEC sp_addmessage 60026, 16,
	N'dbo.UpdatePerson: ������ ���!', @lang='russian'

EXEC sp_dropmessage 60027, @lang='russian'
EXEC sp_dropmessage 60027, @lang='us_english'
EXEC sp_addmessage 60027, 16,
	N'dbo.UpdatePerson: documents (@s_doc+@n_doc) already exists!', @lang='us_english'
EXEC sp_addmessage 60027, 16,
	N'dbo.UpdatePerson: ������ ������� ���!', @lang='russian'

EXEC sp_dropmessage 60030, @lang='russian'
EXEC sp_dropmessage 60030, @lang='us_english'
EXEC sp_addmessage 60030, 16,
	N'dbo.AddErrors: persid doesn''t exist!', @lang='us_english'
EXEC sp_addmessage 60030, 16,
	N'dbo.AddErrors: ������� �������������� persid!', @lang='russian'

EXEC sp_dropmessage 60031, @lang='russian'
EXEC sp_dropmessage 60031, @lang='us_english'
EXEC sp_addmessage 60031, 16,
	N'dbo.LoadErrors: both @enp and @c_err are empty!', @lang='us_english'
EXEC sp_addmessage 60031, 16,
	N'dbo.LoadErrors: @enp � @c_err ������!', @lang='russian'

-- ������ ��������� dbo.UpdatePerson

/*
EXEC sp_dropmessage 60001, @lang='russian'
EXEC sp_dropmessage 60001, @lang='us_english'
EXEC sp_addmessage 60001, 16,
	N'Bulk updates from kmsview are prohibited!', @lang='us_english'
EXEC sp_addmessage 60001, 16,
	N'��������� ��������� �� ������������� ���������!', @lang='russian'

EXEC sp_dropmessage 50001, @lang='russian'
EXEC sp_dropmessage 50001, @lang='us_english'
EXEC sp_addmessage 50001, 16,
	N'DOC.MODDOC trigger rejection! Trying to edit irrelevant record!', @lang='us_english'
EXEC sp_addmessage 50001, 16,
	N'����� �������� doc.moddoc. ������� ��������������� ������������ ������!', @lang='russian'

EXEC sp_dropmessage 50002, @lang='russian'
EXEC sp_dropmessage 50002, @lang='us_english'
EXEC sp_addmessage 50002, 16,
	N'DOC.MODDOC trigger rejection! Uniqueness violation during editing!', @lang='us_english'
EXEC sp_addmessage 50002, 16,
	N'����� �������� doc.moddoc. ��������� ������������ s_doc+n_doc!', @lang='russian'

EXEC sp_dropmessage 50003, @lang='russian'
EXEC sp_dropmessage 50003, @lang='us_english'
EXEC sp_addmessage 50003, 16,
	N'DOC.DELDOC trigger rejection! Deleting irrelevant record is prohibited!', @lang='us_english'
EXEC sp_addmessage 50003, 16,
	N'����� �������� doc.deldoc. ������� ������� ������������ ������!', @lang='russian'

EXEC sp_dropmessage 50501, @lang='russian'
EXEC sp_dropmessage 50501, @lang='us_english'
EXEC sp_addmessage 50501, 16,
	N'DOC.MODDOC trigger rejection! Editing of irrelevant record is prohibited!', @lang='us_english'
EXEC sp_addmessage 50501, 16,
	N'����� �������� doc.moddoc. ������� ��������������� ������������ ������!', @lang='russian'

EXEC sp_dropmessage 50503, @lang='russian'
EXEC sp_dropmessage 50503, @lang='us_english'
EXEC sp_addmessage 50503, 16,
	N'PERMISS.ADDPERMISS trigger rejection! Empty c_perm, s_perm or n_perm value!', @lang='us_english'
EXEC sp_addmessage 50503, 16,
	N'����� �������� permiss.addpermiss. ������� �������� ������ c_perm, s_perm ��� n_perm!', @lang='russian'

EXEC sp_dropmessage 50504, @lang='russian'
EXEC sp_dropmessage 50504, @lang='us_english'
EXEC sp_addmessage 50504, 16,
	N'DOC.MODDOC trigger rejection! s_doc+n_doc!', @lang='us_english'
EXEC sp_addmessage 50504, 16,
	N'����� �������� doc.moddoc. G s_doc+n_doc!', @lang='russian'

EXEC sp_dropmessage 90001, @lang='russian'
EXEC sp_dropmessage 90001, @lang='us_english'
EXEC sp_addmessage 90001, 16,
	N'����� ��������� AddPerson! ������ ����!', @lang='us_english'
EXEC sp_addmessage 90001, 16,
	N'����� ��������� AddPerson! ������ ����!', @lang='russian'

EXEC sp_dropmessage 90002, @lang='russian'
EXEC sp_dropmessage 90002, @lang='us_english'
EXEC sp_addmessage 90002, 16,
	N'����� ��������� AddPerson! ������ ��!', @lang='us_english'
EXEC sp_addmessage 90002, 16,
	N'����� ��������� AddPerson! ������ ��!', @lang='russian'

EXEC sp_dropmessage 90101, @lang='russian'
EXEC sp_dropmessage 90101, @lang='us_english'
EXEC sp_addmessage 90101, 16,
	N'AddMove procedure refusal: empty birthdate!', @lang='us_english'
EXEC sp_addmessage 90101, 16,
	N'����� ��������� AddMove: ������ ���� ��������!', @lang='russian'

EXEC sp_dropmessage 90102, @lang='russian'
EXEC sp_dropmessage 90102, @lang='us_english'
EXEC sp_addmessage 90102, 16,
	N'AddMove procedure refusal: wrong sex!', @lang='us_english'
EXEC sp_addmessage 90102, 16,
	N'����� ��������� AddMove: ������������ ��� ��������!', @lang='russian'

EXEC sp_dropmessage 90103, @lang='russian'
EXEC sp_dropmessage 90103, @lang='us_english'
EXEC sp_addmessage 90103, 16,
	N'AddMove procedure refusal: wrong citizenship!', @lang='us_english'
EXEC sp_addmessage 90103, 16,
	N'����� ��������� AddMove: ������������ ����������� ���������������!', @lang='russian'

EXEC sp_dropmessage 90104, @lang='russian'
EXEC sp_dropmessage 90104, @lang='us_english'
EXEC sp_addmessage 90104, 16,
	N'AddMove procedure refusal: empty place of birth!', @lang='us_english'
EXEC sp_addmessage 90104, 16,
	N'����� ��������� AddMove: �� ��������� ����� ��������!', @lang='russian'

EXEC sp_dropmessage 90105, @lang='russian'
EXEC sp_dropmessage 90105, @lang='us_english'
EXEC sp_addmessage 90105, 16,
	N'AddMove procedure refusal: empty surname!', @lang='us_english'
EXEC sp_addmessage 90105, 16,
	N'����� ��������� AddMove: �� ��������� �������!', @lang='russian'

EXEC sp_dropmessage 90106, @lang='russian'
EXEC sp_dropmessage 90106, @lang='us_english'
EXEC sp_addmessage 90106, 16,
	N'AddMove procedure refusal: empty name!', @lang='us_english'
EXEC sp_addmessage 90106, 16,
	N'����� ��������� AddMove: �� ��������� ���!', @lang='russian'

EXEC sp_dropmessage 90107, @lang='russian'
EXEC sp_dropmessage 90107, @lang='us_english'
EXEC sp_addmessage 90107, 16,
	N'AddMove procedure refusal: empty lastname!', @lang='us_english'
EXEC sp_addmessage 90107, 16,
	N'����� ��������� AddMove: �� ��������� ��������!', @lang='russian'

EXEC sp_dropmessage 90108, @lang='russian'
EXEC sp_dropmessage 90108, @lang='us_english'
EXEC sp_addmessage 90108, 16,
	N'AddMove procedure refusal: empty c_doc!', @lang='us_english'
EXEC sp_addmessage 90108, 16,
	N'����� ��������� AddMove: �� ��������� ���� ��� ���!', @lang='russian'

EXEC sp_dropmessage 90109, @lang='russian'
EXEC sp_dropmessage 90109, @lang='us_english'
EXEC sp_addmessage 90109, 16,
	N'AddMove procedure refusal: empty s_doc!', @lang='us_english'
EXEC sp_addmessage 90109, 16,
	N'����� ��������� AddMove: �� ��������� ���� ����� ���!', @lang='russian'

EXEC sp_dropmessage 90110, @lang='russian'
EXEC sp_dropmessage 90110, @lang='us_english'
EXEC sp_addmessage 90110, 16,
	N'AddMove procedure refusal: empty n_doc!', @lang='us_english'
EXEC sp_addmessage 90110, 16,
	N'����� ��������� AddMove: �� ��������� ���� ����� ���!', @lang='russian'

EXEC sp_dropmessage 90111, @lang='russian'
EXEC sp_dropmessage 90111, @lang='us_english'
EXEC sp_addmessage 90111, 16,
	N'AddMove procedure refusal: empty d_doc!', @lang='us_english'
EXEC sp_addmessage 90111, 16,
	N'����� ��������� AddMove: �� ��������� ���� ���� ������ ���!', @lang='russian'

EXEC sp_dropmessage 90201, @lang='russian'
EXEC sp_dropmessage 90201, @lang='us_english'
EXEC sp_addmessage 90201, 16,
	N'AddMove procedure refusal: empty recid!', @lang='us_english'
EXEC sp_addmessage 90201, 16,
	N'����� ��������� AddMove: ������ recid!', @lang='russian'

EXEC sp_dropmessage 90202, @lang='russian'
EXEC sp_dropmessage 90202, @lang='us_english'
EXEC sp_addmessage 90202, 16,
	N'AddMove procedure refusal: empty recid!', @lang='us_english'
EXEC sp_addmessage 90202, 16,
	N'����� ��������� AddMove: ������������ recid!', @lang='russian'

EXEC sp_dropmessage 90300, @lang='russian'
EXEC sp_dropmessage 90300, @lang='us_english'
EXEC sp_addmessage 90300, 16,
	N'����� ��������� AddMove! ������������ �������� ��� ���������� ������ ���������������!', @lang='us_english'
EXEC sp_addmessage 90300, 16,
	N'����� ��������� AddMove! ������������ �������� ��� ���������� ������ ���������������!', @lang='russian'

EXEC sp_dropmessage 90301, @lang='russian'
EXEC sp_dropmessage 90301, @lang='us_english'
EXEC sp_addmessage 90301, 16,
	N'UpdatePerson: empty recid!', @lang='us_english'
EXEC sp_addmessage 90301, 16,
	N'����� ��������� UpdatePerson: ������ recid!', @lang='russian'

EXEC sp_dropmessage 90302, @lang='russian'
EXEC sp_dropmessage 90302, @lang='us_english'
EXEC sp_addmessage 90302, 16,
	N'UpdatePerson: wrong recid!', @lang='us_english'
EXEC sp_addmessage 90302, 16,
	N'����� ��������� UpdatePerson: �������������� recid!', @lang='russian'

EXEC sp_dropmessage 90303, @lang='russian'
EXEC sp_dropmessage 90303, @lang='us_english'
EXEC sp_addmessage 90303, 16,
	N'UpdatePeeson! Wrong scenario for adding!', @lang='us_english'
EXEC sp_addmessage 90303, 16,
	N'����� ��������� UpdateMove: ������������ ��������!', @lang='russian'

EXEC sp_dropmessage 90401, @lang='russian'
EXEC sp_dropmessage 90401, @lang='us_english'
EXEC sp_addmessage 90401, 16,
	N'UpdatePeeson: VS already exists!', @lang='us_english'
EXEC sp_addmessage 90401, 16,
	N'����� ��������� UpdateMove: ������ ��!', @lang='russian'
*/


print 'User Defined Errors have been created!'
print 'Run CreateDictionaries.sql now!'
