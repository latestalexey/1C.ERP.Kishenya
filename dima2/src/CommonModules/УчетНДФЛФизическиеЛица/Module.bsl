#Область СлужебныеПроцедурыИФункции

// Возвращает подготовленный запрос, формирующий временную таблицу с указанным именем.
// Временная таблица содержит поля Период, ФизическоеЛицо, СтатусНалогоплательщика.
//
// Параметры:
//		ТолькоРазрешенные
//		ОписательВременнойТаблицыОтборов - Структура, см. КадровыйУчет.ОписаниеВременнойТаблицыОтборовФизическихЛиц.
//		ПоляОтбораПериодическихДанных - Соответствие
//		ИмяВТСведенияОСтатусахНалогоплательщиков - Строка, имя временной таблицы, созданной в результате выполнения запроса.
//
// ВозвращаемоеЗначение:
//		Запрос
//
Функция ЗапросВТСведенияОСтатусахНалогоплательщиков(ТолькоРазрешенные, ОписательВременнойТаблицыОтборов, ПоляОтбораПериодическихДанных, ИмяВТСведенияОСтатусахНалогоплательщиков = "ВТСведенияОСтатусахНалогоплательщиков") Экспорт
	
	ИмяВТПредварительныеСведенияОСтатусахНалогоплательщиков = ЗарплатаКадрыОбщиеНаборыДанных.УникальноеИмяТекстаЗапроса("ВТПредварительныеСведенияОСтатусахНалогоплательщиков");
	
	ОписаниеФильтра = ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(
		ОписательВременнойТаблицыОтборов.ИмяВременнойТаблицыОтборовФизическихЛиц,
		"Период,ФизическоеЛицо");
	
	ОписаниеФильтра.СоответствиеИзмеренийРегистраИзмерениямФильтра.Вставить("Период", ОписательВременнойТаблицыОтборов.ИмяПоляПериод);
	ОписаниеФильтра.СоответствиеИзмеренийРегистраИзмерениямФильтра.Вставить("ФизическоеЛицо", ОписательВременнойТаблицыОтборов.ИмяПоляФизическоеЛицо);
	
	ПараметрыПостроения = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистраСрез();
	
	ПоляОтбора = Неопределено;
	Если ПоляОтбораПериодическихДанных <> Неопределено Тогда
		ПоляОтбораПериодическихДанных.Свойство("СтатусФизическихЛицКакНалогоплательщиковНДФЛ", ПоляОтбора);
	КонецЕсли;
	 
	ПараметрыПостроения.Отборы = ПоляОтбора;
	ПараметрыПостроения.ИспользоватьРасширениеЯзыкаЗапросовДляСКД = Ложь;
	
	ЗапросВТИмяРегистраСрез = ЗарплатаКадрыОбщиеНаборыДанных.ЗапросВТИмяРегистраСрез(
		"СтатусФизическихЛицКакНалогоплательщиковНДФЛ",
		ТолькоРазрешенные,
		ОписаниеФильтра,
		ПараметрыПостроения,
		Истина,
		ИмяВТПредварительныеСведенияОСтатусахНалогоплательщиков);
	 
	КадровыйУчет.УстановитьПутьКПолюФизическоеЛицо(ЗапросВТИмяРегистраСрез.Текст, "ИзмеренияДаты", ОписательВременнойТаблицыОтборов.ИмяПоляФизическоеЛицо);
	
	ТекстЗапросаДанных =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ТаблицаОтборовФизическихЛиц.Период КАК Период,
		|	ПредварительныеСведенияОСтатусахНалогоплательщиков.ПериодЗаписи КАК ПериодЗаписи,
		|	ТаблицаОтборовФизическихЛиц.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ВЫБОР
		|		КОГДА ТаблицаОтборовФизическихЛиц.Период < ДАТАВРЕМЯ(2014, 1, 1, 0, 0, 0)
		|				И ПредварительныеСведенияОСтатусахНалогоплательщиков.Статус = ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.Беженцы)
		|			ТОГДА ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.Нерезидент)
		|		ИНАЧЕ ЕСТЬNULL(ПредварительныеСведенияОСтатусахНалогоплательщиков.Статус, ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.Резидент))
		|	КОНЕЦ КАК СтатусНалогоплательщика
		|ПОМЕСТИТЬ ВТСведенияОСтатусахНалогоплательщиков
		|ИЗ
		|	ВТОтборовФизическихЛиц КАК ТаблицаОтборовФизическихЛиц
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПредварительныеСведенияОСтатусахНалогоплательщиков КАК ПредварительныеСведенияОСтатусахНалогоплательщиков
		|		ПО ТаблицаОтборовФизическихЛиц.Период = ПредварительныеСведенияОСтатусахНалогоплательщиков.Период
		|			И ТаблицаОтборовФизическихЛиц.ФизическоеЛицо = ПредварительныеСведенияОСтатусахНалогоплательщиков.ФизическоеЛицо";
		
	ТекстЗапросаДанных = СтрЗаменить(ТекстЗапросаДанных, "ВТОтборовФизическихЛиц", ОписательВременнойТаблицыОтборов.ИмяВременнойТаблицыОтборовФизическихЛиц);
	ТекстЗапросаДанных = СтрЗаменить(ТекстЗапросаДанных, "ТаблицаОтборовФизическихЛиц.Период", "ТаблицаОтборовФизическихЛиц." + ОписательВременнойТаблицыОтборов.ИмяПоляПериод);
	КадровыйУчет.УстановитьВТекстеЗапросаИмяПоляФизическоеЛицо(ТекстЗапросаДанных, "ТаблицаОтборовФизическихЛиц.ФизическоеЛицо", ОписательВременнойТаблицыОтборов.ИмяПоляФизическоеЛицо);
	ТекстЗапросаДанных = СтрЗаменить(ТекстЗапросаДанных, "ВТПредварительныеСведенияОСтатусахНалогоплательщиков", ИмяВТПредварительныеСведенияОСтатусахНалогоплательщиков);
	
	ЗарплатаКадрыОбщиеНаборыДанных.ЗаменитьИмяСоздаваемойВременнойТаблицы(ТекстЗапросаДанных, "ВТСведенияОСтатусахНалогоплательщиков", ИмяВТСведенияОСтатусахНалогоплательщиков);
	ЗарплатаКадрыОбщиеНаборыДанных.УстановитьВыборкуТолькоРазрешенныхДанных(ТекстЗапросаДанных, ТолькоРазрешенные);
	
	ЗапросВТИмяРегистраСрез.Текст = 
		ЗапросВТИмяРегистраСрез.Текст
		+ ЗарплатаКадрыОбщиеНаборыДанных.РазделительЗапросов()
		+ ТекстЗапросаДанных;
	
	Возврат ЗапросВТИмяРегистраСрез;
	
КонецФункции

// Сведения о статусе налогоплательщика.

Функция ДобавитьПолеСведенийОСтатусахНалогоплательщиков(ИмяПоля, ТекстОписанияПолей, ИсточникиДанных) Экспорт
	
	ДобавленоПолеСведений = Ложь;
	Если НеобходимыСведенияОСтатусахНалогоплательщиков(ИмяПоля) Тогда
		
		ДобавленоПолеСведений = Истина;
		ИсточникиДанных.Вставить("СведенияОСтатусахНалогоплательщиков", Истина);
		
		ПутьКДанным = ПутьКДаннымСведенийОСтатусахНалогоплательщиков(ИмяПоля);
		ТекстОписанияПолей = ТекстОписанияПолей + "," + Символы.ПС + ПутьКДанным + " КАК " + ИмяПоля;
		
	КонецЕсли;
	
	Возврат ДобавленоПолеСведений;
	
КонецФункции

Процедура ДобавитьТекстЗапросаВТСведенияОСтатусахНалогоплательщиков(Запрос, ТолькоРазрешенные, ОписательВременнойТаблицыОтборов, ПоляОтбораПериодическихДанных, ИсточникиДанных) Экспорт
	
	Если ИсточникиДанных.Получить("СведенияОСтатусахНалогоплательщиков") = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ИмяВТСведенияОСтатусахНалогоплательщиков = ЗарплатаКадрыОбщиеНаборыДанных.УникальноеИмяТекстаЗапроса("ВТСведенияОСтатусахНалогоплательщиков");
	
	ЗапросВТ = ЗапросВТСведенияОСтатусахНалогоплательщиков(ТолькоРазрешенные, ОписательВременнойТаблицыОтборов, ПоляОтбораПериодическихДанных, ИмяВТСведенияОСтатусахНалогоплательщиков);
			
	ЗарплатаКадрыОбщиеНаборыДанных.СкопироватьПараметрыЗапроса(Запрос, ЗапросВТ);
	
	Запрос.Текст = 
		ЗапросВТ.Текст
		+ ЗарплатаКадрыОбщиеНаборыДанных.РазделительЗапросов()
		+ Запрос.Текст;
		
	Запрос.Текст = Запрос.Текст + Символы.ПС
		+ "		{ЛЕВОЕ СОЕДИНЕНИЕ " + ИмяВТСведенияОСтатусахНалогоплательщиков + " КАК СтатусыНалогоплательщиков
			|		ПО " + КадровыйУчет.ПутьКПолюФизическоеЛицо("ТаблицаОтборовФизическихЛиц", ОписательВременнойТаблицыОтборов.ИмяПоляФизическоеЛицо) + " = СтатусыНалогоплательщиков.ФизическоеЛицо
			|			И ТаблицаОтборовФизическихЛиц." + ОписательВременнойТаблицыОтборов.ИмяПоляПериод + " = СтатусыНалогоплательщиков.Период}";
				
КонецПроцедуры

Функция НеобходимыСведенияОСтатусахНалогоплательщиков(Знач ИмяПоля) Экспорт
	
	Возврат ВРег(ИмяПоля) = ВРег("СтатусНалогоплательщикаПериодРегистрации")
		Или ВРег(ИмяПоля) = ВРег("СтатусНалогоплательщика");
	
КонецФункции

Функция ДобавитьКритерийПоискаПоСведениямОСтатусахНалогоплательщиков(КритерииПоиска, УсловиеПоиска) Экспорт
	
	КритерийДобавлен = Ложь;
	Если НеобходимыСведенияОСтатусахНалогоплательщиков(УсловиеПоиска.ЛевоеЗначение) Тогда
		
		ИмяПоля = ВРег(УсловиеПоиска.ЛевоеЗначение);
		Если ИмяПоля = ВРег("СтатусНалогоплательщикаПериодРегистрации") Тогда
			УсловиеПоиска.ЛевоеЗначение = "Период";
			
		КонецЕсли;
		
		КадровыйУчет.ДобавитьКритерийПоискаСотрудников(КритерииПоиска, "РегистрСведений.СтатусФизическихЛицКакНалогоплательщиковНДФЛ", УсловиеПоиска);
		КритерийДобавлен = Истина;
		
	КонецЕсли; 
	
	Возврат КритерийДобавлен;
	
КонецФункции

Функция ПутьКДаннымСведенийОСтатусахНалогоплательщиков(Знач ИмяПоля)
	
	ИмяПоляВВерхнемРегистре = ВРег(ИмяПоля);
	
	ПутьКДанным = "";
	Если ИмяПоляВВерхнемРегистре = ВРег("СтатусНалогоплательщикаПериодРегистрации") Тогда
		ПутьКДанным = "	СтатусыНалогоплательщиков.ПериодЗаписи";
	Иначе
		ПутьКДанным = "	СтатусыНалогоплательщиков." + ИмяПоля;
	КонецЕсли;
	
	Возврат ПутьКДанным;
	
КонецФункции

#КонецОбласти
