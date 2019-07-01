
#Область СлужебныйПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СправкиНДФЛЗаполнитьПолеИтогов(ДанныеСправки, ДанныеИтоговПоСтавке, ИмяПоля) Экспорт
КонецПроцедуры	

Процедура СправкиНДФЛУстановитьПризнакНаличияГражданства(Форма, ДанныеСправки) Экспорт
	Если ДанныеСправки.Гражданство = ПредопределенноеЗначение("Справочник.СтраныМира.ПустаяСсылка") Тогда
		Форма.ЛицоБезГражданства = 1;
		Форма.Элементы.Гражданство.Доступность = Ложь;
	Иначе
		Форма.ЛицоБезГражданства = 0;
		Форма.Элементы.Гражданство.Доступность = Истина;
	КонецЕсли;			
КонецПроцедуры

Процедура СправкиНДФЛУстановитьСвойстваЭлементовСФиксациейДанных(Форма, ДанныеСправки, ДокументПроведен = Ложь) Экспорт
	ИменаФиксируемыхПолей = СправкиНДФЛИменаФиксируемыхПолей();
	
	ЕстьФиксированныеДанные = Ложь;
	Для Каждого ИмяПоля Из ИменаФиксируемыхПолей Цикл
		СправкиНДФЛУстановитьСвойстваЭлементаФиксируемыхДанных(Форма, ДанныеСправки, ИмяПоля, ДокументПроведен);	
		
		ЕстьФиксированныеДанные = ЕстьФиксированныеДанные Или ДанныеСправки["Фикс" + ИмяПоля];
	КонецЦикла;	
	
	Форма.Элементы.ОтменитьИсправленияДанныхСотрудника.Доступность = ЕстьФиксированныеДанные;
КонецПроцедуры

Процедура СправкиНДФЛУстановитьСвойстваЭлементаФиксируемыхДанных(Форма, ДанныеСправки, ИмяПоля, ДокументПроведен = Ложь) Экспорт
	Элементы = Новый Массив;
	Элементы.Добавить(Форма.Элементы[ИмяПоля]);
	Если ИмяПоля = "Гражданство" Тогда
		Элементы.Добавить(Форма.Элементы["ЛицоБезГражданства"]);
		ИННвСтранеГражданства = Форма.Элементы.Найти("ИННвСтранеГражданства");
		Если ИННвСтранеГражданства <> Неопределено Тогда
			Элементы.Добавить(ИННвСтранеГражданства);
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого Элемент Из Элементы Цикл
		Если ДанныеСправки["Фикс" + ИмяПоля] И 
			Элемент.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать Тогда
			
			Элемент.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
			
		ИначеЕсли Элемент.ОтображениеПредупрежденияПриРедактировании =  ОтображениеПредупрежденияПриРедактировании.НеОтображать
			И Не ДанныеСправки["Фикс" + ИмяПоля] И Не ДокументПроведен Тогда
			
			Элемент.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать;	
		ИначеЕсли ДокументПроведен И Элемент.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать Тогда
			
			Элемент.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.НеОтображать;	
		КонецЕсли;
	КонецЦикла;	
 КонецПроцедуры	

Функция СправкиНДФЛИменаФиксируемыхПолей() Экспорт
	ЗаполняемыеПоля = Новый Массив;
	ЗаполняемыеПоля.Добавить("ИНН");
	ЗаполняемыеПоля.Добавить("Фамилия");
	ЗаполняемыеПоля.Добавить("Имя");
	ЗаполняемыеПоля.Добавить("Отчество");
	ЗаполняемыеПоля.Добавить("Адрес");
	ЗаполняемыеПоля.Добавить("ВидДокумента");
	ЗаполняемыеПоля.Добавить("СерияДокумента");
	ЗаполняемыеПоля.Добавить("НомерДокумента");
	ЗаполняемыеПоля.Добавить("Гражданство");
	ЗаполняемыеПоля.Добавить("ДатаРождения");
	ЗаполняемыеПоля.Добавить("СтатусНалогоплательщика");
	ЗаполняемыеПоля.Добавить("АдресЗарубежом");	
	
	Возврат ЗаполняемыеПоля;
КонецФункции	

Процедура СправкиНДФЛУстановитьИнфонадписьИсправления(Инфонадпись, ДанныеСправки, ДокументПроведен = Ложь, ДляНалогаНаПрибыль = Ложь) Экспорт
	ФиксируемыеПоля = СправкиНДФЛИменаФиксируемыхПолей();
	
	ЕстьЗафиксированныеДанные = Ложь;
	Для Каждого ИмяПоля Из ФиксируемыеПоля Цикл
		Если ДанныеСправки["Фикс" + ИмяПоля] Тогда	
			ЕстьЗафиксированныеДанные = Истина;
		КонецЕсли;	
	КонецЦикла;
	
	Если ДляНалогаНаПрибыль Тогда
		Если ДокументПроведен Тогда
			Инфонадпись = НСтр("ru='Документ проведен, данные получателя дохода зафиксированы и могут отличаться от данных в его карточке';uk='Документ проведено, дані одержувача доходу зафіксовані і можуть відрізнятися від даних у його картці'");	
		ИначеЕсли ЕстьЗафиксированныеДанные Тогда
			Инфонадпись = НСтр("ru='Выделенные жирным шрифтом данные были зафиксированы в документе и могут отличаться от данных в карточке получателя дохода';uk='Виділені жирним шрифтом дані були зафіксовані в документі та можуть відрізнятися від даних у картці одержувача доходу'");	
		Иначе
			Инфонадпись = НСтр("ru='Данные о получателе дохода берутся из его карточки автоматически.';uk='Дані про одержувача доходу беруться з його картки автоматично.'");		
		КонецЕсли;	
	Иначе
		Если ДокументПроведен Тогда
			Инфонадпись = НСтр("ru='Документ проведен, данные сотрудника зафиксированы и могут отличаться от данных в карточке сотрудника';uk='Документ проведено, дані співробітника зафіксовані і можуть відрізнятися від даних в картці співробітника'");	
		ИначеЕсли ЕстьЗафиксированныеДанные Тогда
			Инфонадпись = НСтр("ru='Выделенные жирным шрифтом данные были зафиксированы в документе и могут отличаться от данных в карточке сотрудника';uk='Виділені жирним шрифтом дані були зафіксовані в документі та можуть відрізнятися від даних в картці співробітника'");	
		Иначе
			Инфонадпись = НСтр("ru='Данные о сотруднике берутся из карточки сотрудника автоматически.';uk='Дані про співробітника беруться з картки співробітника автоматично.'");		
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры		

Функция СправкиНДФЛДокументИспользуетКодОКТМО(ДанныеДокумента) Экспорт
	Если ДанныеДокумента.НалоговыйПериод >= 2013 
		И Не ДанныеДокумента.СпециальныйДокумент2013года Тогда 
		
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;	
КонецФункции	

Функция МесяцНалоговогоПериодаСтрокой(НомерМесяца) Экспорт
	Возврат Формат(Дата(2012, НомерМесяца, 1), "ДФ=ММММ");	
КонецФункции	

#КонецОбласти

#Область ПанельПримененныеВычеты

// См. функцию УчетНДФЛКлиентСерверВнутренний.ОписаниеПанелиВычеты.
//
Функция ОписаниеПанелиВычеты() Экспорт
	
	Возврат УчетНДФЛКлиентСерверВнутренний.ОписаниеПанелиВычеты();
	
КонецФункции

// См. функцию УчетНДФЛКлиентСерверВнутренний.ОписаниеТабличнойЧастиНДФЛ.
//
Функция ОписаниеТабличнойЧастиНДФЛ() Экспорт
	
	Возврат УчетНДФЛКлиентСерверВнутренний.ОписаниеТабличнойЧастиНДФЛ();
	
КонецФункции

Функция НДФЛТекущиеДанные(Форма, ОписаниеПанелиВычеты) Экспорт

	Возврат УчетНДФЛКлиентСерверВнутренний.НДФЛТекущиеДанные(Форма, ОписаниеПанелиВычеты);
	
КонецФункции

Процедура ДополнитьПредставлениеВычетов(ПредставлениеВычетов, КодВычета, СуммаВычета) Экспорт
	
	Если ЗначениеЗаполнено(КодВычета) И ЗначениеЗаполнено(СуммаВычета) Тогда
		ПредставлениеВычетов = ПредставлениеВычетов + СуммаВычета;
	КонецЕсли; 
					
КонецПроцедуры

Процедура ЗаполнитьПредставлениеВычетовЛичныхСтрокиНДФЛ(Форма, СтрокаНДФЛ, ОписаниеПанелиВычеты) Экспорт
	
	ВычетыЛичные = ОписаниеПанелиВычеты.НастраиваемыеПанели.Получить("ВычетыЛичные");
	Если ВычетыЛичные <> Неопределено Тогда
	
		СтрокаНДФЛ.ПредставлениеВычетовЛичных = 0;
		ДополнитьПредставлениеВычетов(СтрокаНДФЛ.ПредставлениеВычетовЛичных, СтрокаНДФЛ.ПримененныйВычетЛичныйКодВычета, СтрокаНДФЛ.ПримененныйВычетЛичный);
		ДополнитьПредставлениеВычетов(СтрокаНДФЛ.ПредставлениеВычетовЛичных, СтрокаНДФЛ.ПримененныйВычетЛичныйКЗачетуВозвратуКодВычета, СтрокаНДФЛ.ПримененныйВычетЛичныйКЗачетуВозврату);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура НазначитьИдентификаторСтрокеНДФЛ(СтрокаНДФЛ, МаксимальныйИдентификаторСтрокиНДФЛ, НоваяСтрока) Экспорт
	
	Если Не НоваяСтрока Или СтрокаНДФЛ.ИдентификаторСтрокиНДФЛ > 0 Тогда
		Возврат;
	КонецЕсли;
	
	МаксимальныйИдентификаторСтрокиНДФЛ = МаксимальныйИдентификаторСтрокиНДФЛ + 1;
	СтрокаНДФЛ.ИдентификаторСтрокиНДФЛ = МаксимальныйИдентификаторСтрокиНДФЛ;
	
КонецПроцедуры

Функция ФормаПодробнееОРасчетеНДФЛОписаниеТаблицыНДФЛ() Экспорт
	
	Возврат УчетНДФЛКлиентСерверВнутренний.ФормаПодробнееОРасчетеНДФЛОписаниеТаблицыНДФЛ();
	
КонецФункции

#КонецОбласти
