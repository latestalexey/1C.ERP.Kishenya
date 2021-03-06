////////////////////////////////////////////////////////////////////////////////
// ЗарплатаКадрыОтчеты: Методы, используемые для работы отчетов.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Содержит настройки размещения вариантов отчетов в панели отчетов.
// Описание см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчетов(Настройки) Экспорт
	
	ЗарплатаКадрыОтчетыВнутренний.НастроитьВариантыОтчетов(Настройки);
	ЗарплатаКадрыОтчетыПереопределяемый.НастроитьВариантыОтчетов(Настройки);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

// Добавляет элемент отбора, предварительно проверив доступность поля отбора.
//
// Параметры:
//		Отбор - ОтборКомпоновкиДанных
//		ИмяПоля - Строка
//		ВидСравнения - Системное перечисление ВидСравненияКомпоновкиДанных.
//		ПравоеЗначение - любое значение.
//
Процедура ДобавитьЭлементОтбора(Отбор, ИмяПоля, ВидСравнения, ПравоеЗначение) Экспорт
	
	Если Отбор.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ИмяПоля)) <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			Отбор, ИмяПоля, ВидСравнения, ПравоеЗначение);
			
	КонецЕсли; 
	
КонецПроцедуры

Функция КлючВарианта(КомпоновщикНастроек) Экспорт
	
	КлючВарианта = Неопределено;
	Если Не ЗначениеЗаполнено(КлючВарианта) Тогда
		
		НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
		ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КлючВарианта"));
		Если ЗначениеПараметра <> Неопределено
			И ЗначениеПараметра.Использование
			И ЗначениеЗаполнено(ЗначениеПараметра.Значение) Тогда
			
				КлючВарианта = ЗначениеПараметра.Значение;
			
		КонецЕсли; 
		
	КонецЕсли; 
	
	Возврат КлючВарианта;
	
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция СоответствиеПользовательскихПолей(НастройкиОтчета) Экспорт
	
	ЭлементыПользовательскихПолей = НастройкиОтчета.ПользовательскиеПоля.Элементы;
	
	СоответствиеПользовательскихПолей = Новый Соответствие;
	
	Для каждого Элемент Из ЭлементыПользовательскихПолей Цикл
		СоответствиеПользовательскихПолей.Вставить(Элемент.Заголовок, СтрЗаменить(Элемент.ПутьКДанным,".",""));
	КонецЦикла;
	
	Возврат СоответствиеПользовательскихПолей;
	
КонецФункции

Процедура ЗаполнитьПараметрыПользовательскихПолей(Макет, Данные, СоответствиеПользовательскихПолей, ИменаЗаполняемыхПолей = "") Экспорт
	
	ЗаполняемыеПоля = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаЗаполняемыхПолей);
	
	СтруктураДанных = Новый Структура;
	Для каждого СоответствиеПользовательскогоПоля Из СоответствиеПользовательскихПолей Цикл
		
		Если ЗаполняемыеПоля.Количество() > 0
			И ЗаполняемыеПоля.Найти(СоответствиеПользовательскогоПоля.Ключ) = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		
		СтруктураДанных.Вставить(СоответствиеПользовательскогоПоля.Значение);
		
	КонецЦикла;
	
	ЗаполнитьЗначенияСвойств(СтруктураДанных, Данные);
	
	СтруктураЗначенийПользовательскихПолей = Новый Структура;
	Для каждого СоответствиеПользовательскогоПоля Из СоответствиеПользовательскихПолей Цикл
		
		Если ЗаполняемыеПоля.Количество() > 0
			И ЗаполняемыеПоля.Найти(СоответствиеПользовательскогоПоля.Ключ) = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		
		СтруктураЗначенийПользовательскихПолей.Вставить(СоответствиеПользовательскогоПоля.Ключ, СтруктураДанных[СоответствиеПользовательскогоПоля.Значение]);
		
	КонецЦикла;
	
	ЗаполнитьЗначенияСвойств(Макет.Параметры, СтруктураЗначенийПользовательскихПолей);
	
КонецПроцедуры

Процедура ЗаполнитьПользовательскиеПоляВариантаОтчета(КлючВарианта, НастройкиОтчета) Экспорт
	
	ЗарплатаКадрыОтчетыВнутренний.ЗаполнитьПользовательскиеПоляВариантаОтчета(КлючВарианта, НастройкиОтчета);
	
КонецПроцедуры

Процедура НастроитьВариантОтчетаРасчетныйЛисток(НастройкиОтчета) Экспорт
	
	ЗарплатаКадрыОтчетыВнутренний.НастроитьВариантОтчетаРасчетныйЛисток(НастройкиОтчета);
	
КонецПроцедуры

Процедура ОтчетАнализНачисленийИУдержанийПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ЗарплатаКадрыОтчетыВнутренний.ОтчетАнализНачисленийИУдержанийПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД);
	
КонецПроцедуры

#КонецОбласти

