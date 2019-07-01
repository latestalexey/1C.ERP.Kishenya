#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
		
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ШтатныеСотрудники");
	НастройкиВарианта.Описание =
		НСтр("ru='Список сотрудников, работающих по трудовым договорам с окладами, 
        |сведениями об авансе, графиком работы и личной информацией'
        |;uk='Список працівників, які працюють за трудовими договорами з окладами, 
        |відомостями про аванс, графіком роботи та особистою інформацією'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ЛичныеДанныеСотрудников");
	НастройкиВарианта.Описание =
		НСтр("ru='Паспортные данные, КодПоДРФО дата рождения и прочие личные данные';uk='Паспортні дані, КодПоДРФО дата народження та інші особисті дані'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "УволенныеСотрудники");
	НастройкиВарианта.Описание =
		НСтр("ru='Список уволенных на заданную дату сотрудников';uk='Список звільнених на задану дату співробітників'");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли