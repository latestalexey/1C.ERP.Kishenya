#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Справка о списании депонированной зарплаты.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.РегистрацияПрочихДоходов";
	КомандаПечати.Идентификатор = "ПФ_MXL_СправкаОРегистрацииПрочихДоходов";
	КомандаПечати.Представление = НСтр("ru='Справка о регистрации прочих доходов';uk='Довідка про реєстрацію інших доходів'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.ДополнитьКомплектВнешнимиПечатнымиФормами = Истина;

КонецПроцедуры

// Формирует печатные формы
//
// Параметры:
//  (входные)
//    МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//    ПараметрыПечати - Структура - дополнительные настройки печати;
//  (выходные)
//   КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы.
//   ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                             представление - имя области в которой был выведен объект;
//   ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	НужноПечататьСправку = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_СправкаОРегистрацииПрочихДоходов");
	
	Если НужноПечататьСправку Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПФ_MXL_СправкаОРегистрацииПрочихДоходов",
			НСтр("ru='Справка о выплате бывшим сотрудникам';uk='Довідка про виплату колишнім співробітникам'"), ПечатьСправки(МассивОбъектов, ОбъектыПечати, ПараметрыВывода), ,
			"Документ.РегистрацияПрочихДоходов.ПФ_MXL_СправкаОРегистрацииПрочихДоходов",, Истина);
	КонецЕсли;
						
КонецПроцедуры								

Функция ПечатьСправки(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	
	ДокументРезультат = Новый ТабличныйДокумент;
	ДокументРезультат.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РегистрацияПрочихДоходов_СправкаОРегистрацииПрочихДоходов";
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ДокументРезультат.АвтоМасштаб = Истина;
	
	ДанныеПечатиОбъектов = ДанныеПечатиДокументов(МассивОбъектов);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РегистрацияПрочихДоходов.ПФ_MXL_СправкаОРегистрацииПрочихДоходов", КодЯзыкаПечать);
		
	ОбластьМакетаШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакетаШапкаПовторятьПриПечати = Макет.ПолучитьОбласть("ШапкаПовторятьПриПечати");
	ОбластьМакетаСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьМакетаПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ПервыйДокумент = Истина;
	
	Для Каждого ДанныеПечати Из ДанныеПечатиОбъектов Цикл
		
		ДанныеДокумента = ДанныеПечати.Значение;
		
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйДокумент = Ложь;
		КонецЕсли;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ДокументРезультат.ВысотаТаблицы + 1;
		
		ОбластьМакетаШапка.Параметры.Заполнить(ДанныеДокумента);
		ДокументРезультат.Вывести(ОбластьМакетаШапка);
		
		Для каждого ДанныеСотрудника Из ДанныеДокумента.ТабличнаяЧастьДокумента Цикл
			
			МассивВыводимыхОбластей = Новый Массив;
			МассивВыводимыхОбластей.Добавить(ОбластьМакетаСтрока);
			МассивВыводимыхОбластей.Добавить(ОбластьМакетаПодвал);
			Если НЕ ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ДокументРезультат, МассивВыводимыхОбластей) Тогда
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
				ДокументРезультат.Вывести(ОбластьМакетаШапкаПовторятьПриПечати);
			КонецЕсли;
			
			ОбластьМакетаСтрока.Параметры.Заполнить(ДанныеСотрудника);
			
			ДокументРезультат.Вывести(ОбластьМакетаСтрока);
			
		КонецЦикла;
		
		ОбластьМакетаПодвал.Параметры.Заполнить(ДанныеДокумента);
		ДокументРезультат.Вывести(ОбластьМакетаПодвал);
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ДокументРезультат, НомерСтрокиНачало, ОбъектыПечати, ДанныеДокумента.Ссылка);
				
	КонецЦикла;
	
	Возврат ДокументРезультат;
		
КонецФункции

Функция ДанныеПечатиДокументов(МассивОбъектов)
	
	ДанныеПечатиОбъектов = Новый Соответствие;
	
	ВалютаУчета = ЗарплатаКадры.ВалютаУчетаЗаработнойПлаты();
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РегистрацияПрочихДоходов.Ссылка.Организация.НаименованиеПолное КАК Организация,
	|	РегистрацияПрочихДоходов.Ссылка.Подразделение.Наименование КАК Подразделение,
	|	РегистрацияПрочихДоходов.Ссылка КАК Ссылка,
	|	РегистрацияПрочихДоходов.Ссылка.Номер,
	|	НАЧАЛОПЕРИОДА(РегистрацияПрочихДоходов.Ссылка.Дата, ДЕНЬ) КАК Дата,
	|	РегистрацияПрочихДоходов.Ссылка.ВидПрочегоДохода,
	|	РегистрацияПрочихДоходов.ФизическоеЛицо,
	|	РегистрацияПрочихДоходов.НДФЛ КАК НДФЛ,
	|	РегистрацияПрочихДоходов.Начислено КАК СуммаДохода,
	|	РегистрацияПрочихДоходов.КВыплате КАК СуммаКВыплате,
	|	РегистрацияПрочихДоходов.Ссылка.Исполнитель.ФИО КАК Исполнитель,
	|	РегистрацияПрочихДоходов.Ссылка.ДолжностьИсполнителя КАК ДолжностьИсполнителя
	|ИЗ
	|	Документ.РегистрацияПрочихДоходов.НачисленияУдержанияВзносы КАК РегистрацияПрочихДоходов
	|ГДЕ
	|	РегистрацияПрочихДоходов.Ссылка В(&МассивОбъектов)
	|ИТОГИ
	|	СУММА(СуммаДохода)
	|ПО
	|	Ссылка";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	РезультатЗапроса = Запрос.Выполнить();
	ГруппировкаПоДокументу = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ГруппировкаПоДокументу.Следующий() Цикл
		
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("Ссылка", ГруппировкаПоДокументу.Ссылка);
		ДанныеПечати.Вставить("НазваниеОрганизации", ГруппировкаПоДокументу.Организация);
		ДанныеПечати.Вставить("НазваниеПодразделения", ГруппировкаПоДокументу.Подразделение);
		ДанныеПечати.Вставить("ЕдиницаИзмерения", ВалютаУчета.НаименованиеПолное);
		ДанныеПечати.Вставить("ВидПрочегоДохода", ГруппировкаПоДокументу.ВидПрочегоДохода);
		ДанныеПечати.Вставить("ДатаДокумента", Формат(ГруппировкаПоДокументу.Дата, "ДЛФ=D"));
		ДанныеПечати.Вставить("НомерДокумента", ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ГруппировкаПоДокументу.Номер, Истина, Истина));
		ДанныеПечати.Вставить("ДолжностьИсполнителя", ГруппировкаПоДокументу.ДолжностьИсполнителя);
		ДанныеПечати.Вставить("ИсполнительРасшифровкаПодписи", ФизическиеЛицаЗарплатаКадры.РасшифровкаПодписи(Строка(ГруппировкаПоДокументу.Исполнитель)));
		ДанныеПечати.Вставить("ТабличнаяЧастьДокумента", Новый Массив);
		
		ГруппировкаПоСотрудникам = ГруппировкаПоДокументу.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
		Пока ГруппировкаПоСотрудникам.Следующий() Цикл
			
			СтрокаДанныхПечати = Новый Структура;
			СтрокаДанныхПечати.Вставить("Получатель", "");
			СтрокаДанныхПечати.Вставить("СуммаДохода", ГруппировкаПоСотрудникам.СуммаДохода);
			СтрокаДанныхПечати.Вставить("СуммаКВыплате", ГруппировкаПоСотрудникам.СуммаКВыплате);
			СтрокаДанныхПечати.Вставить("НДФЛ", ГруппировкаПоСотрудникам.НДФЛ);
			
			ДанныеФизическогоЛица = КадровыйУчет.КадровыеДанныеФизическихЛиц(
				Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ГруппировкаПоСотрудникам.ФизическоеЛицо), 
				"ФИОПолные,Пол", ГруппировкаПоДокументу.Дата);
			
			Если ДанныеФизическогоЛица.Количество() > 0 Тогда
				СтрокаДанныхПечати.Получатель = ДанныеФизическогоЛица[0].ФИОПолные;
			КонецЕсли;			
			
			ДанныеПечати.ТабличнаяЧастьДокумента.Добавить(СтрокаДанныхПечати);
			
		КонецЦикла;		
		
		ДанныеПечатиОбъектов.Вставить(ГруппировкаПоДокументу.Ссылка, ДанныеПечати);
		
	КонецЦикла;
	
	Возврат ДанныеПечатиОбъектов;
		
КонецФункции

#КонецОбласти

Процедура ЗаполнитьРеквизитыКВыплате() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	РегистрацияПрочихДоходовНачисления.Ссылка,
		|	СУММА(РегистрацияПрочихДоходовНачисления.КВыплате) КАК КВыплате,
		|	РегистрацияПрочихДоходовНачисления.Ссылка.ВсегоВыплачено
		|ПОМЕСТИТЬ ВТДокументыСИтогами
		|ИЗ
		|	Документ.РегистрацияПрочихДоходов.НачисленияУдержанияВзносы КАК РегистрацияПрочихДоходовНачисления
		|
		|СГРУППИРОВАТЬ ПО
		|	РегистрацияПрочихДоходовНачисления.Ссылка,
		|	РегистрацияПрочихДоходовНачисления.Ссылка.ВсегоВыплачено
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТДокументыСИтогами.Ссылка
		|ИЗ
		|	ВТДокументыСИтогами КАК ВТДокументыСИтогами
		|ГДЕ
		|	ВТДокументыСИтогами.КВыплате <> ВТДокументыСИтогами.ВсегоВыплачено";
		
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ДокументОбъект.ВсегоВыплачено = ДокументОбъект.НачисленияУдержанияВзносы.Итог("КВыплате");
			
			ДокументОбъект.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			ДокументОбъект.ОбменДанными.Загрузка = Истина;
			ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
			
		КонецЦикла; 
		
	КонецЕсли; 
		
КонецПроцедуры

Функция ДанныеДляБухучетаЗарплатыПервичныхДокументов(Объект) Экспорт

	ДанныеДляБухучета = Новый Структура;
	ДанныеДляБухучета.Вставить("ДокументОснование", Объект.Ссылка);
	
	ТаблицаБухучетЗарплаты = ОтражениеЗарплатыВБухучетеРасширенный.НоваяТаблицаБухучетЗарплатыПервичныхДокументов();
	НоваяСтрока = ТаблицаБухучетЗарплаты.Добавить();
	НоваяСтрока.ДокументОснование = Объект.Ссылка;
	НоваяСтрока.НачислениеУдержание = Объект.ВидПрочегоДохода;
	НоваяСтрока.СпособОтраженияЗарплатыВБухучете = Объект.СпособОтраженияЗарплатыВБухучете;
	НоваяСтрока.СтатьяФинансирования = Объект.СтатьяФинансирования;
	НоваяСтрока.СтатьяРасходов = Объект.СтатьяРасходов;
	
	ДанныеДляБухучета.Вставить("ТаблицаБухучетЗарплаты", ТаблицаБухучетЗарплаты);
	
	Возврат ДанныеДляБухучета;
	
КонецФункции

Процедура СоздатьВТДанныеДокумента(МенеджерВременныхТаблиц, ДокументСсылка, СписокФизическихЛиц = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Начисления.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Начисления.Ссылка.Организация,
		|	Начисления.Ссылка.ВидПрочегоДохода.КодДоходаНДФЛ КАК КодДохода,
		|	Начисления.Ссылка.ВидПрочегоДохода.ДоходВНатуральнойФорме КАК ДоходВНатуральнойФорме,
		|	Начисления.Начислено КАК СуммаДохода,
		|	Начисления.Ссылка.ПланируемаяДатаВыплаты КАК ПланируемаяДатаВыплаты,
		|	НАЧАЛОПЕРИОДА(Начисления.Ссылка.ПланируемаяДатаВыплаты, МЕСЯЦ) КАК МесяцНалоговогоПериода,
		|	НАЧАЛОПЕРИОДА(Начисления.Ссылка.ПериодРегистрации, МЕСЯЦ) КАК ПериодРегистрации,
		|	Начисления.Ссылка.Подразделение КАК Подразделение,
		|	Начисления.Начислено КАК Сумма,
		|	Начисления.НДФЛ КАК НДФЛ,
		|	Начисления.Ссылка.ВидПрочегоДохода КАК Начисление,
		|	Начисления.Ссылка,
		|	Начисления.Ссылка.СтатьяФинансирования,
		|	Начисления.Ссылка.СтатьяРасходов,
		|	Начисления.Ссылка.СпособОтраженияЗарплатыВБухучете,
		|	Начисления.НомерСтроки
		|ПОМЕСТИТЬ ВТДанныеДокумента
		|ИЗ
		|	Документ.РегистрацияПрочихДоходов.НачисленияУдержанияВзносы КАК Начисления
		|ГДЕ
		|	Начисления.Ссылка = &Ссылка
		|	И Начисления.ФизическоеЛицо В(&СписокФизическихЛиц)";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Если СписокФизическихЛиц = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Начисления.ФизическоеЛицо В(&СписокФизическихЛиц)", "");
	Иначе
		Запрос.УстановитьПараметр("СписокФизическихЛиц", СписокФизическихЛиц);
	КонецЕсли;
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура СоздатьВТНачисленияДокумента(МенеджерВременныхТаблиц, ДокументОбъект, Организация, ПериодРегистрации) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплата") Тогда
		
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ДанныеДокумента.ПериодРегистрации КАК ПериодРегистрации,
			|	ДанныеДокумента.Организация,
			|	ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка) КАК Сотрудник,
			|	ДанныеДокумента.ФизическоеЛицо,
			|	ДанныеДокумента.Подразделение,
			|	ДанныеДокумента.Подразделение КАК ТерриторияВыполненияРаботВОрганизации,
			|	ДанныеДокумента.Начисление,
			|	ДанныеДокумента.ВидДохода,
			|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоЗарплате.ПустаяСсылка) КАК ВидОперации,
			|	НАЧАЛОПЕРИОДА(ДанныеДокумента.ПериодРегистрации, МЕСЯЦ) КАК ДатаНачала,
			|	КОНЕЦПЕРИОДА(ДанныеДокумента.ПериодРегистрации, МЕСЯЦ) КАК ДатаОкончания,
			|	ДанныеДокумента.НомерСтроки КАК ИдентификаторСтроки,
			|	ДанныеДокумента.Сумма,
			|	ДанныеДокумента.СуммаВычета,
			|	ДанныеДокумента.Ссылка КАК ДокументОснование
			|ПОМЕСТИТЬ ВТНачисления
			|ИЗ
			|	ВТДанныеДокумента КАК ДанныеДокумента";
			
		Запрос.Выполнить();
		
		ДанныеФормы = ОтражениеЗарплатыВБухучетеРасширенный.ДополнительныеПараметрыДляОтраженияВБухучете();
		ДанныеФормы.БухучетПервичногоДокумента = Документы.РегистрацияПрочихДоходов.ДанныеДляБухучетаЗарплатыПервичныхДокументов(ДокументОбъект).ТаблицаБухучетЗарплаты;
		ДанныеФормы.ДокументСсылка = ДокументОбъект.Ссылка;
		ОтражениеЗарплатыВБухучетеРасширенный.СоздатьВТБухучетНачислений(ДокументОбъект.Организация, НачалоМесяца(ДокументОбъект.ПериодРегистрации), 0, Запрос.МенеджерВременныхТаблиц, ДанныеФормы);
		
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Начисления.ПериодРегистрации,
			|	Начисления.Организация,
			|	Начисления.Сотрудник,
			|	Начисления.ФизическоеЛицо,
			|	Начисления.Подразделение,
			|	Начисления.Начисление,
			|	Начисления.ВидДохода,
			|	Начисления.ДатаНачала,
			|	Начисления.ДатаОкончания,
			|	Начисления.ДокументОснование,
			|	БухучетНачислений.СтатьяФинансирования,
			|	БухучетНачислений.СтатьяРасходов,
			|	БухучетНачислений.СпособОтраженияЗарплатыВБухучете,
			|	БухучетНачислений.Сумма
			|ПОМЕСТИТЬ ВТНачисленияДокумента
			|ИЗ
			|	ВТНачисления КАК Начисления
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТБухучетНачислений КАК БухучетНачислений
			|		ПО Начисления.ИдентификаторСтроки = БухучетНачислений.ИдентификаторСтроки
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|УНИЧТОЖИТЬ ВТНачисления
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|УНИЧТОЖИТЬ ВТБухучетНачислений";
		
	Иначе
		
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Начисления.ПериодРегистрации,
			|	Начисления.Организация,
			|	ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка) КАК Сотрудник,
			|	Начисления.ФизическоеЛицо,
			|	Начисления.Подразделение,
			|	Начисления.Начисление,
			|	НАЧАЛОПЕРИОДА(Начисления.ПериодРегистрации, МЕСЯЦ) КАК ДатаНачала,
			|	КОНЕЦПЕРИОДА(Начисления.ПериодРегистрации, МЕСЯЦ) КАК ДатаОкончания,
			|	Начисления.Ссылка КАК ДокументОснование,
			|	ЗНАЧЕНИЕ(Справочник.СтатьиФинансированияЗарплата.ПустаяСсылка) КАК СтатьяФинансирования,
			|	ЗНАЧЕНИЕ(Справочник.СтатьиРасходовЗарплата.ПустаяСсылка) КАК СтатьяРасходов,
			|	ЗНАЧЕНИЕ(Справочник.СпособыОтраженияЗарплатыВБухучете.ПустаяСсылка) КАК СпособОтраженияЗарплатыВБухучете,
			|	Начисления.Сумма
			|ПОМЕСТИТЬ ВТНачисленияДокумента
			|ИЗ
			|	ВТДанныеДокумента КАК Начисления";
		
	КонецЕсли;
	
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ДанныеДляПроведениеНДФЛ(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеДокумента.ФизическоеЛицо,
		|	ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка) КАК Сотрудник,
		|	ЗНАЧЕНИЕ(ПланВидовРасчета.Начисления.ПустаяСсылка) КАК Начисление,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.КодДохода,
		|	ДанныеДокумента.ПланируемаяДатаВыплаты КАК ДатаПолученияДохода,
		|	ДанныеДокумента.Сумма КАК СуммаДохода,
		|	ДанныеДокумента.ДоходВНатуральнойФорме КАК НатуральныйКоэффициент,
		|	ДанныеДокумента.НДФЛ КАК Сумма,
		|	ДанныеДокумента.МесяцНалоговогоПериода,
		|	ДанныеДокумента.Подразделение,
		|	ДанныеДокумента.Подразделение КАК ПодразделениеСотрудника
		|ИЗ
		|	ВТДанныеДокумента КАК ДанныеДокумента
		|";
		
	ДанныеУчетаНДФЛ = Запрос.ВыполнитьПакет()[0].Выгрузить();
	
	Возврат ДанныеУчетаНДФЛ;
	
КонецФункции

Функция ДанныеДляПроведенияНДФЛИВычетов(МенеджерВременныхТаблиц) Экспорт
	
		ДанныеДляПроведения = Неопределено;
	Возврат ДанныеДляПроведения;
	
	
КонецФункции

Функция ДанныеДляПроведенияВзносы(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.ФизическоеЛицо,
		|	ДанныеДокумента.Подразделение,
		|	ДанныеДокумента.Начисление,
		|	ДанныеДокумента.ДатаНачала,
		|	ДанныеДокумента.Сумма
		|ИЗ
		|	ВТНачисленияДокумента КАК ДанныеДокумента";
	
	Возврат Запрос.Выполнить().Выгрузить();;
	
КонецФункции

#КонецОбласти

#КонецЕсли