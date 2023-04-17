SELECT @@LANGUAGE AS 'Language Name' -- Este comando es para saber en que lenguaje se encuentra.

--Despues se ejecuta este comando

SET LANGUAGE Spanish

exec sp_defaultlanguage sa, 'spanish'