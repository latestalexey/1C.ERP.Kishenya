
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_MXL_UK_ЛистокСообщения";
	КомандаПечати.Представление = НСтр("ru='Листок сообщения';uk='Листок повідомлення'");
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст
//                           ошибки).
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя
//                           области в которой был выведен объект).
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_UK_ЛистокСообщения") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
				КоллекцияПечатныхФорм,
				"ПФ_MXL_UK_ЛистокСообщения", НСтр("ru='Листок сообщения';uk='Листок повідомлення'"),
				ПечатнаяФормаЛисткаСообщения(МассивОбъектов, ОбъектыПечати), ,
				"Документ.ЛистокСообщенияДляВоенкомата.ПФ_MXL_UK_ЛистокСообщения");

	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру, содержащие сведения о кратком и полном составе семьи для листка сообщения.
//
Функция СведенияОСоставеСемьи(ФизическоеЛицоСсылка) Экспорт 
	
	Супруга 			 = "";
	Дети 				 = "";
	БлижайшийРодственник = "";
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицоСсылка);
	Запрос.УстановитьПараметр("Муж",  "01");
	Запрос.УстановитьПараметр("Жена", "02");
	Запрос.УстановитьПараметр("Отец", "03");
	Запрос.УстановитьПараметр("Мать", "04");
	Запрос.УстановитьПараметр("Сын",  "05");
	Запрос.УстановитьПараметр("Дочь", "06");
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РодственникиФизическихЛиц.СтепеньРодства КАК СтепеньРодства,
	|	РодственникиФизическихЛиц.Наименование КАК ФИО,
	|	РодственникиФизическихЛиц.ДатаРождения КАК ДатаРождения,
	|	РодственникиФизическихЛиц.СтепеньРодства.Код КАК СтепеньРодстваКод
	|ПОМЕСТИТЬ ВТСоставСемьи
	|ИЗ
	|	Справочник.РодственникиФизическихЛиц КАК РодственникиФизическихЛиц
	|ГДЕ
	|	РодственникиФизическихЛиц.Владелец = &ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТСоставСемьи.СтепеньРодства КАК СтепеньРодства,
	|	ВТСоставСемьи.СтепеньРодстваКод КАК СтепеньРодстваКод,
	|	ВТСоставСемьи.ФИО КАК ФИО,
	|	ВТСоставСемьи.ДатаРождения КАК ДатаРождения
	|ИЗ
	|	ВТСоставСемьи КАК ВТСоставСемьи
	|ГДЕ
	|	ВТСоставСемьи.СтепеньРодстваКод В (&Муж, &Жена, &Сын, &Дочь)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВТСоставСемьи.ДатаРождения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТСоставСемьи.СтепеньРодства КАК СтепеньРодства,
	|	ВТСоставСемьи.ФИО КАК ФИО
	|ИЗ
	|	ВТСоставСемьи КАК ВТСоставСемьи
	|ГДЕ
	|	ВТСоставСемьи.СтепеньРодстваКод = &Мать
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТСоставСемьи.СтепеньРодства,
	|	ВТСоставСемьи.ФИО
	|ИЗ
	|	ВТСоставСемьи КАК ВТСоставСемьи
	|ГДЕ
	|	ВТСоставСемьи.СтепеньРодстваКод = &Отец
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТСоставСемьи.СтепеньРодства,
	|	ВТСоставСемьи.ФИО
	|ИЗ
	|	ВТСоставСемьи КАК ВТСоставСемьи
	|ГДЕ
	|	НЕ ВТСоставСемьи.СтепеньРодстваКод В (&Муж, &Жена, &Отец, &Мать, &Сын, &Дочь)";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Выборка = РезультатЗапроса[1].Выбрать();
	
	Пока Выборка.Следующий() Цикл 
		Если Выборка.СтепеньРодстваКод = "05" Или Выборка.СтепеньРодстваКод = "06" Тогда 
			Дети = Дети + ?(ЗначениеЗаполнено(Дети), ", ", "") + Выборка.ФИО + ?(ЗначениеЗаполнено(Выборка.ДатаРождения), ", ", "")
				+ Формат(Выборка.ДатаРождения, "ДФ=""гггг 'г. р.'""");
		Иначе 		
			Супруга = НРег(Выборка.СтепеньРодства) + ": " + Выборка.ФИО;
		КонецЕсли;	
	КонецЦикла;
	
	Выборка = РезультатЗапроса[2].Выбрать();
	
	Если Выборка.Следующий() Тогда 
		БлижайшийРодственник = НРег(Выборка.СтепеньРодства) + ": " + Выборка.ФИО;
	КонецЕсли;
	
	СоставСемьиКраткий = Супруга + ?(ЗначениеЗаполнено(Супруга) И ЗначениеЗаполнено(Дети), ", " + НСтр("ru='дети';uk='діти'") + ": ", "") + Дети;
	
	СоставСемьиПолный  = СоставСемьиКраткий + ?(ЗначениеЗаполнено(СоставСемьиКраткий) И ЗначениеЗаполнено(БлижайшийРодственник), ", ", "") + БлижайшийРодственник;
	СоставСемьиКраткий = ?(ЗначениеЗаполнено(Супруга), СоставСемьиКраткий, СоставСемьиПолный);
	
	Пока Выборка.Следующий() Цикл 
		СоставСемьиПолный = СоставСемьиПолный + ", " + НРег(Выборка.СтепеньРодства) + ": " + Выборка.ФИО;
	КонецЦикла;
	
	СведенияОСемье = Новый Структура;
	
	СведенияОСемье.Вставить("СоставСемьиКраткий", СоставСемьиКраткий);
	СведенияОСемье.Вставить("СоставСемьиПолный", СоставСемьиПолный);
	
	Возврат СведенияОСемье;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ФУНКЦИИ ПЕЧАТИ БЛАНКОВ ВОИНСКОГО УЧЕТА

Функция ПечатнаяФормаЛисткаСообщения(МассивОбъектов, ОбъектыПечати)
	
	НастройкиПечатныхФорм = ЗарплатаКадрыПовтИсп.НастройкиПечатныхФорм();
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЛистокСообщения";
	
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	//Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЛистокСообщенияДляВоенкомата.ПФ_MXL_ЛистокСообщения");
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЛистокСообщенияДляВоенкомата.ПФ_MXL_UK_ЛистокСообщения");
	
	ОбластьМакетаЛисток = Макет.ПолучитьОбласть("Листок"); 
	
	ДанныеДляПечати = ДанныеДляПечатиЛисткаСообщения(МассивОбъектов).Выбрать();
	
	Пока ДанныеДляПечати.Следующий() Цикл
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		ОтветственныеЛица = ОтветственныеЛицаСервер.ПолучитьОтветственныеЛицаОрганизации(ДанныеДляПечати.Организация, ДанныеДляПечати.Дата);

		ЗаполнитьЗначенияСвойств(ОбластьМакетаЛисток.Параметры, ДанныеДляПечати);
		ЗаполнитьЗначенияСвойств(ОбластьМакетаЛисток.Параметры, ОтветственныеЛица);
		
		
		
		Если ТипЗнч(ДанныеДляПечати.ДатаВыдачи) = Тип("Дата") Тогда
			ОбластьМакетаЛисток.Параметры.ДатаВыдачи = Формат(ДанныеДляПечати.ДатаВыдачи, "Л=uk_UA; ДЛФ=DD"); 
		КонецЕсли;
		
		
		
		
		МассивДлинСтрок = Новый Массив;
		МассивДлинСтрок.Добавить(66);
		МассивДлинСтрок.Добавить(96);
		
		РезультирующаяСтрока = ЗарплатаКадры.РазбитьСтрокуНаПодСтроки(ДанныеДляПечати.ОписаниеИзменений, МассивДлинСтрок);
		Для Счетчик = 1 По ?(СтрЧислоСтрок(РезультирующаяСтрока) <= 4, СтрЧислоСтрок(РезультирующаяСтрока), 4)  Цикл
			ОбластьМакетаЛисток.Параметры["СменаДанных"+Счетчик] = СтрЗаменить(СтрПолучитьСтроку(РезультирующаяСтрока, Счетчик),Символы.ПС, "");  
		КонецЦикла;
		
		МассивДлинСтрок.Установить(0,55);
		
		РезультирующаяСтрокаВоенкомат = ЗарплатаКадры.РазбитьСтрокуНаПодСтроки(ДанныеДляПечати.Военкомат, МассивДлинСтрок);
		Для Счетчик = 1 По ?(СтрЧислоСтрок(РезультирующаяСтрокаВоенкомат) <= 2, СтрЧислоСтрок(РезультирующаяСтрокаВоенкомат), 2)  Цикл
			ОбластьМакетаЛисток.Параметры["Военкомат"+Счетчик] = СтрЗаменить(СтрПолучитьСтроку(РезультирующаяСтрокаВоенкомат, Счетчик),Символы.ПС, "");  
		КонецЦикла;
		
		МассивДлинСтрок.Установить(0,63);
		
		РезультирующаяСтрокаАдрес = ЗарплатаКадры.РазбитьСтрокуНаПодСтроки(ДанныеДляПечати.АдресМестаПроживания, МассивДлинСтрок);
		Для Счетчик = 1 По ?(СтрЧислоСтрок(РезультирующаяСтрокаАдрес) <= 2, СтрЧислоСтрок(РезультирующаяСтрокаАдрес), 2)  Цикл
			ОбластьМакетаЛисток.Параметры["АдресМестаПроживания"+Счетчик] = СтрЗаменить(СтрПолучитьСтроку(РезультирующаяСтрокаАдрес, Счетчик),Символы.ПС, "");  
		КонецЦикла;
		
		Если НастройкиПечатныхФорм.ВыводитьПолнуюИерархиюПодразделений И ЗначениеЗаполнено(ОбластьМакетаЛисток.Параметры.Подразделение) Тогда
			ОбластьМакетаЛисток.Параметры.Подразделение = ОбластьМакетаЛисток.Параметры.Подразделение.ПолноеНаименование();
		КонецЕсли;
		
		ТабДокумент.Вывести(ОбластьМакетаЛисток); 
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеДляПечати.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции

Функция ДанныеДляПечатиЛисткаСообщения(МассивСсылок)

	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	Запрос.Текст = 
	
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЛистокСообщенияДляВоенкомата.Ссылка КАК Ссылка,
	|	ЛистокСообщенияДляВоенкомата.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЛистокСообщенияДляВоенкомата.ДатаРождения КАК ДатаРождения,
	|	ЛистокСообщенияДляВоенкомата.Звание КАК Звание,
	|	ЛистокСообщенияДляВоенкомата.ВУС КАК ВУС,
	|	ЛистокСообщенияДляВоенкомата.АдресМестаПроживанияПредставление КАК АдресМестаПроживания,
	|	ЛистокСообщенияДляВоенкомата.ОписаниеИзменений,
	|	ЛистокСообщенияДляВоенкомата.Организация,
	|	ЛистокСообщенияДляВоенкомата.Дата
	|ПОМЕСТИТЬ ДанныеЛистка
	|ИЗ
	|	Документ.ЛистокСообщенияДляВоенкомата КАК ЛистокСообщенияДляВоенкомата
	|ГДЕ
	|	ЛистокСообщенияДляВоенкомата.Ссылка В(&МассивСсылок)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ЕСТЬNULL(ВоинскийУчет.Военкомат, 0) КАК Военкомат,
	|	ДанныеЛистка.Ссылка,
	|	ДанныеЛистка.ФизическоеЛицо,
	|	ДанныеЛистка.ДатаРождения,
	|	ДанныеЛистка.Звание,
	|	ДанныеЛистка.ВУС,
	|	ДанныеЛистка.АдресМестаПроживания,
	|	ДанныеЛистка.ОписаниеИзменений,
	|	ДанныеЛистка.Организация,
	|	ДанныеЛистка.Дата
	|ПОМЕСТИТЬ ПромежуточнаяТаблица
	|ИЗ
	|	ДанныеЛистка КАК ДанныеЛистка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВоинскийУчет КАК ВоинскийУчет
	|		ПО ДанныеЛистка.ФизическоеЛицо = ВоинскийУчет.ФизическоеЛицо
	|			И ДанныеЛистка.Дата >= ВоинскийУчет.Период
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВоинскийУчет.Период УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ПромежуточнаяТаблица.Военкомат,
	|	ПромежуточнаяТаблица.Ссылка,
	|	ПромежуточнаяТаблица.ФизическоеЛицо,
	|	ПромежуточнаяТаблица.ДатаРождения,
	|	ПромежуточнаяТаблица.Звание,
	|	ПромежуточнаяТаблица.ВУС,
	|	ПромежуточнаяТаблица.АдресМестаПроживания,
	|	ПромежуточнаяТаблица.ОписаниеИзменений,
	|	ЕСТЬNULL(ДокументыФизическихЛиц.Серия, ""_____"") КАК Серия,
	|	ЕСТЬNULL(ДокументыФизическихЛиц.Номер, ""__________"") КАК Номер,
	|	ЕСТЬNULL(ДокументыФизическихЛиц.ДатаВыдачи, ""___  _______ 20__ р."") КАК ДатаВыдачи,
	|	ПромежуточнаяТаблица.Организация,
	|	ПромежуточнаяТаблица.Дата
	|ИЗ
	|	ПромежуточнаяТаблица КАК ПромежуточнаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ПО ПромежуточнаяТаблица.ФизическоеЛицо = ДокументыФизическихЛиц.Физлицо
	|			И ПромежуточнаяТаблица.Дата >= ДокументыФизическихЛиц.Период" ;
	
	Возврат Запрос.Выполнить();
	
КонецФункции

#КонецОбласти

#Область МеханизмФиксацииИзменений

Функция ПараметрыФиксацииВторичныхДанных() Экспорт
	Возврат ФиксацияВторичныхДанныхВДокументах.ПараметрыФиксацииВторичныхДанных(ФиксацияОписаниеФиксацииРеквизитов(), , ФиксацияОписанияТЧ())
КонецФункции

Функция ФиксацияОписаниеФиксацииРеквизитов()
	
	ОписаниеФиксацииРеквизитов = Новый Соответствие;
	
	// ЗАПОЛНЯЕМЫЕ АВТОМАТИЧЕСКИ
	ОписаниеФиксацииРеквизитов.Вставить("Подразделение", 						ФиксацияОписаниеФиксацииРеквизита("Подразделение", "ГруппаОсновныеРеквизиты", "Сотрудник", НСтр("ru='Подразделение заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и используйте соответствующие документы. Если вы хотите изменить подразделение только в этом документе, нажмите ""Да"" и продолжите редактирование';uk='Підрозділ заповнюється автоматично. Якщо ви хочете виправити дані, натисніть кнопку ""Ні"" і використовуйте відповідні документи. Якщо ви хочете змінити підрозділ тільки в цьому документі, натисніть ""Так"" продовжити редагування'")));
	ОписаниеФиксацииРеквизитов.Вставить("ДатаРождения", 						ФиксацияОписаниеФиксацииРеквизита("ДатаРождения", "ГруппаИнформацияЛеваяКолонка", "Сотрудник", НСтр("ru='Дата рождения заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и затем используйте ссылку ""Редактировать карточку сотрудника"". Если вы хотите изменить дату рождения только в этом документе, нажмите ""Да"" и продолжите редактирование';uk='Дата народження заповнюється автоматично. Якщо ви хочете виправити дані, натисніть кнопку ""Ні"" і потім використовувати посилання ""Редагувати картку співробітника"". Якщо ви хочете змінити дату народження тільки в цьому документі, натисніть ""Так"" продовжити редагування'")));
	ОписаниеФиксацииРеквизитов.Вставить("Звание", 								ФиксацияОписаниеФиксацииРеквизита("Звание", "ГруппаИнформацияЛеваяКолонка", "Сотрудник", НСтр("ru='Звание заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и затем используйте ссылку ""Редактировать карточку сотрудника"". Если вы хотите изменить звание только в этом документе, нажмите ""Да"" и продолжите редактирование';uk='Звання заповнюється автоматично. Якщо ви хочете виправити дані, натисніть кнопку ""Ні"" і потім використовувати посилання ""Редагувати картку співробітника"". Якщо ви хочете змінити звання тільки в цьому документі, натисніть ""Так"" продовжити редагування'")));
	ОписаниеФиксацииРеквизитов.Вставить("ВУС", 									ФиксацияОписаниеФиксацииРеквизита("ВУС", "ГруппаИнформацияЛеваяКолонка", "Сотрудник", НСтр("ru='ВУС заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и затем используйте ссылку ""Редактировать карточку сотрудника"". Если вы хотите изменить ВУС только в этом документе, нажмите ""Да"" и продолжите редактирование';uk='ВОС заповнюється автоматично. Якщо ви хочете виправити дані, натисніть кнопку ""Ні"" і потім використовувати посилання ""Редагувати картку співробітника"". Якщо ви хочете змінити ВОС тільки в цьому документі, натисніть ""Так"" продовжити редагування'")));
	ОписаниеФиксацииРеквизитов.Вставить("Образование", 							ФиксацияОписаниеФиксацииРеквизита("Образование", "ГруппаИнформацияЛеваяКолонка", "Сотрудник", НСтр("ru='Образование заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и затем используйте ссылку ""Редактировать карточку сотрудника"". Если вы хотите изменить образование только в этом документе, нажмите ""Да"" и продолжите редактирование';uk='Освіта заповнюється автоматично. Якщо ви хочете виправити дані, натисніть кнопку ""Ні"" і потім використовувати посилання ""Редагувати картку співробітника"". Якщо ви хочете змінити освіту тільки в цьому документі, натисніть ""Так"" продовжити редагування'")));
	ОписаниеФиксацииРеквизитов.Вставить("Должность", 							ФиксацияОписаниеФиксацииРеквизита("Должность", "ГруппаИнформацияЛеваяКолонка", "Сотрудник", НСтр("ru='Должность заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и используйте соответствующие документы. Если вы хотите изменить подразделение только в этом документе, нажмите ""Да"" и продолжите редактирование';uk='Посада заповнюється автоматично. Якщо ви хочете виправити дані, натисніть кнопку ""Ні"" і використовуйте відповідні документи. Якщо ви хочете змінити підрозділ тільки в цьому документі, натисніть ""Так"" продовжити редагування'")));
	ОписаниеФиксацииРеквизитов.Вставить("АдресМестаПроживанияПредставление", 	ФиксацияОписаниеФиксацииРеквизита("АдресМестаПроживанияПредставление", "ГруппаИнформацияЛеваяКолонка", "Сотрудник", НСтр("ru='Адрес заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и затем используйте ссылку ""Редактировать карточку сотрудника"". Если вы хотите изменить адрес только в этом документе, нажмите ""Да"" и продолжите редактирование';uk='Адреса заповнюється автоматично. Якщо ви хочете виправити дані, натисніть кнопку ""Ні"" і потім використовувати посилання ""Редагувати картку співробітника"". Якщо ви хочете змінити адресу тільки в цьому документі, натисніть ""Так"" продовжити редагування'")));
	ОписаниеФиксацииРеквизитов.Вставить("СемейноеПоложение", 					ФиксацияОписаниеФиксацииРеквизита("СемейноеПоложение", "ГруппаИнформацияПраваяКолонка", "Сотрудник", НСтр("ru='Семейное положение заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и затем используйте ссылку ""Редактировать карточку сотрудника"". Если вы хотите изменить семейное положение только в этом документе, нажмите ""Да"" и продолжите редактирование';uk='Сімейний стан заповнюється автоматично. Якщо ви хочете виправити дані, натисніть кнопку ""Ні"" і потім використовувати посилання ""Редагувати картку співробітника"". Якщо ви хочете змінити сімейний стан тільки в цьому документі, натисніть ""Так"" продовжити редагування'")));
	ОписаниеФиксацииРеквизитов.Вставить("СоставСемьи", 							ФиксацияОписаниеФиксацииРеквизита("СоставСемьи", "ГруппаИнформацияПраваяКолонка", "Сотрудник", НСтр("ru='Состав семьи заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и затем используйте ссылку ""Редактировать карточку сотрудника"". Если вы хотите изменить семейное положение только в этом документе, нажмите ""Да"" и продолжите редактирование';uk='Склад сім''ї заповнюється автоматично. Якщо ви хочете виправити дані, натисніть кнопку ""Ні"" і потім використовувати посилання ""Редагувати картку співробітника"". Якщо ви хочете змінити сімейний стан тільки в цьому документі, натисніть ""Так"" продовжити редагування'")));
	ОписаниеФиксацииРеквизитов.Вставить("ОтветственныйЗаВУР", 					ФиксацияОписаниеФиксацииРеквизита("ОтветственныйЗаВУР", "СтраницаОсновное", "Организация", НСтр("ru='Ответственный за ВУ заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и отредактируйте данные организации. Если вы хотите изменить ответственного только в этом документе, нажмите ""Да"" и продолжите редактирование';uk='Відповідальний за ВО заповнюється автоматично. Якщо ви хочете виправити дані, натисніть кнопку ""Ні"" і відредагуйте дані організації. Якщо ви хочете змінити відповідального тільки в цьому документі, натисніть ""Так"" продовжіть редагування'")));
	
	Возврат ОписаниеФиксацииРеквизитов;  
	
КонецФункции 

Функция ФиксацияОписанияТЧ()
	
	СтруктураКлючевыхПолей = Новый Структура;
	
	Возврат	СтруктураКлючевыхПолей
КонецФункции

Функция ФиксацияОписаниеФиксацииРеквизита(ИмяРеквизита,
	ИмяГруппы, 
	ОснованиеЗаполнения,
	СтрокаПредупреждения =  "",
	Используется = Истина, 
	РеквизитСтроки = Ложь,
	ФиксацияГруппы = Ложь, 
	Путь = "",
	ОтображатьПредупреждение = Истина)
	
	ФиксацияРеквизита = ФиксацияВторичныхДанныхВДокументах.СтруктураПараметровОписанияФиксацииРеквизитов();
	ФиксацияРеквизита.Вставить("ИмяРеквизита", ИмяРеквизита);
	ФиксацияРеквизита.Вставить("Используется", Используется);
	ФиксацияРеквизита.Вставить("ИмяГруппы", ИмяГруппы);
	ФиксацияРеквизита.Вставить("ФиксацияГруппы", ФиксацияГруппы);
	ФиксацияРеквизита.Вставить("ОснованиеЗаполнения", ОснованиеЗаполнения);
	ФиксацияРеквизита.Вставить("Путь", Путь);
	ФиксацияРеквизита.Вставить("ОтображатьПредупреждение", ОтображатьПредупреждение);
	Если СтрокаПредупреждения <> "" Тогда
		ФиксацияРеквизита.Вставить("СтрокаПредупреждения", СтрокаПредупреждения);
	КонецЕсли;
	ФиксацияРеквизита.Вставить("РеквизитСтроки", РеквизитСтроки);
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксацииРеквизита(ФиксацияРеквизита)
КонецФункции 

#КонецОбласти

#КонецЕсли