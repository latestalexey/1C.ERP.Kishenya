
#Область СлужебныйПрограммныйИнтерфейс


#Область ПанельПримененныеВычеты

// Возвращает максимальное значение идентификатора строки НДФЛ.
//
// Параметры:
//		ТаблицаНДФЛ - ДанныеФормыКоллекция
//
// Возвращаемое значение:
//		Число
//
Функция МаксимальныйИдентификаторСтрокиНДФЛ(ТаблицаНДФЛ) Экспорт
	
	МаксимальныйИдентификаторСтрокиНДФЛ = 0;
	
	Для каждого СтрокаТаблицыНДФЛ Из ТаблицаНДФЛ Цикл
		
		Если МаксимальныйИдентификаторСтрокиНДФЛ < СтрокаТаблицыНДФЛ.ИдентификаторСтрокиНДФЛ Тогда
			МаксимальныйИдентификаторСтрокиНДФЛ = СтрокаТаблицыНДФЛ.ИдентификаторСтрокиНДФЛ;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МаксимальныйИдентификаторСтрокиНДФЛ;
	
КонецФункции

// Назначает идентификаторы строкам таблицы значений НДФЛ и строкам связанной 
// таблицы значений ПримененныеВычетыНаДетейИИмущественные, перед добавление в
// коллекции строк табличных частей объектов.
//
// Параметры:
//		МаксимальныйИдентификаторСтрокиНДФЛ - Число
//		ТаблицаНДФЛ - ТаблицаЗначений
//		ПримененныеВычетыНаДетейИИмущественные - ТаблицаЗначений
//
Процедура НазначитьИдентификаторыНовымСтрокамТаблицамНДФЛИПримененныеВычетыНаДетейИИмущественные(Знач МаксимальныйИдентификаторСтрокиНДФЛ, ТаблицаНДФЛ, ПримененныеВычетыНаДетейИИмущественные) Экспорт
	
	СоответствиеИдентификаторов = Новый Соответствие;
	Для каждого СтрокаТаблицыНДФЛ Из ТаблицаНДФЛ Цикл
		
		СоответствиеИдентификаторов.Вставить(СтрокаТаблицыНДФЛ.ИдентификаторСтрокиНДФЛ, МаксимальныйИдентификаторСтрокиНДФЛ);
		СтрокаТаблицыНДФЛ.ИдентификаторСтрокиНДФЛ = МаксимальныйИдентификаторСтрокиНДФЛ;
		МаксимальныйИдентификаторСтрокиНДФЛ = МаксимальныйИдентификаторСтрокиНДФЛ + 1;
		
	КонецЦикла;
	
	
КонецПроцедуры

// Заполняет вторичные данные формы.
//
// Параметры:
//		Форма	- УправляемаяФорма
//		Период	- Дата, дата в налоговом периоде, в котором применяются вычеты к доходам.
//
Процедура ЗаполнитьВторичныеДанныеТабличныхЧастей(Форма, Период = '00010101', ВыбранныеСотрудники = Неопределено) Экспорт
	
	Если НЕ Форма.ПолучитьФункциональнуюОпциюФормы("ИспользоватьНачислениеЗарплаты") Тогда
		Возврат;
	КонецЕсли; 
	
	Если ВыбранныеСотрудники <> Неопределено Тогда 
		
		ФизическиеЛицаСотрудников = Новый Соответствие;
		ВыбранныеФизическиеЛица = Новый Соответствие;
		
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("ВыбранныеСотрудники", ВыбранныеСотрудники);
		
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	Сотрудники.ФизическоеЛицо
		               |ПОМЕСТИТЬ ВТФизическиеЛица
		               |ИЗ
		               |	Справочник.Сотрудники КАК Сотрудники
		               |ГДЕ
		               |	Сотрудники.Ссылка В(&ВыбранныеСотрудники)
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	Сотрудники.Ссылка КАК Сотрудник,
		               |	Сотрудники.ФизическоеЛицо
		               |ИЗ
		               |	Справочник.Сотрудники КАК Сотрудники
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТФизическиеЛица КАК ФизическиеЛица
		               |		ПО Сотрудники.ФизическоеЛицо = ФизическиеЛица.ФизическоеЛицо";
					   
		УстановитьПривилегированныйРежим(Истина);
		Выборка = Запрос.Выполнить().Выбрать();
		УстановитьПривилегированныйРежим(Ложь);
		
		Пока Выборка.Следующий() Цикл 
			ФизическиеЛицаСотрудников.Вставить(Выборка.Сотрудник, Выборка.ФизическоеЛицо);
			ВыбранныеФизическиеЛица.Вставить(Выборка.ФизическоеЛицо, Истина);
		КонецЦикла;
		
	КонецЕсли;
	
	ОписаниеПанелиВычеты = Форма.ОписаниеПанелиВычетыНаСервере();
	
	ВычетыКДоходам = ОписаниеПанелиВычеты.НастраиваемыеПанели.Получить("ВычетыКДоходам");
	Если ВычетыКДоходам <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, "СоответствиеКодовВычетовКодамДоходов",
			Новый ФиксированноеСоответствие(УчетНДФЛ.ВычетыКДоходам(Год(Период))));
			
		ДанныеВычетовКДоходам = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ВычетыКДоходам);
		
		Сотрудники = ДанныеВычетовКДоходам.Выгрузить(, "Сотрудник");
		Сотрудники.Свернуть("Сотрудник");
		
		Начисления = ДанныеВычетовКДоходам.Выгрузить(, "Начисление");
		Начисления.Свернуть("Начисление");
		
		УстановитьПривилегированныйРежим(Истина);
		Если ВыбранныеСотрудники = Неопределено Тогда 
			ФизическиеЛицаСотрудников = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Сотрудники.ВыгрузитьКолонку("Сотрудник"), "ФизическоеЛицо");
		КонецЕсли;	
		КодыДоходов = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Начисления.ВыгрузитьКолонку("Начисление"), "КодДоходаНДФЛ");
		УстановитьПривилегированныйРежим(Ложь);
		
		Для каждого СтрокаНачисления Из ДанныеВычетовКДоходам Цикл
			
			ФизическоеЛицо = ФизическиеЛицаСотрудников[СтрокаНачисления.Сотрудник];
			Если ВыбранныеСотрудники <> Неопределено И ФизическоеЛицо = Неопределено Тогда 
				Продолжить;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаНачисления.Начисление)
				И ТипЗнч(СтрокаНачисления.Начисление) = Тип("ПланВидовРасчетаСсылка.Начисления") Тогда
				
				СтрокаНачисления.ВычетПримененныйКДоходам = Форма.СоответствиеКодовВычетовКодамДоходов.Получить(КодыДоходов.Получить(СтрокаНачисления.Начисление)) <> Неопределено;
				
			КонецЕсли; 
			
			Если ФизическоеЛицо <> Неопределено Тогда
				СтрокаНачисления.ФизическоеЛицо = ФизическоеЛицо;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли; 
	
	ДанныеНДФЛ = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ОписаниеПанелиВычеты.ТабличнаяЧастьНДФЛ.ПутьКДаннымНДФЛ);
	Форма[ОписаниеПанелиВычеты.ИмяГруппыФормыПанелиВычеты + "МаксимальныйИдентификаторСтрокиНДФЛ"] = МаксимальныйИдентификаторСтрокиНДФЛ(ДанныеНДФЛ);
	
	ДанныеНДФЛСтроки = Новый Массив;
	ИмяПоляФизическоеЛицо = ОписаниеПанелиВычеты.ТабличнаяЧастьНДФЛ.ИмяПоляФизическоеЛицо;
	
	Для каждого СтрокаНДФЛ Из ДанныеНДФЛ Цикл
		Если ВыбранныеСотрудники <> Неопределено И ВыбранныеФизическиеЛица.Получить(СтрокаНДФЛ[ИмяПоляФизическоеЛицо]) = Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		ЗаполнитьПредставленияВычетовСтрокиНДФЛ(Форма, СтрокаНДФЛ, ОписаниеПанелиВычеты);
		ДанныеНДФЛСтроки.Добавить(СтрокаНДФЛ);
	КонецЦикла;
		
	Если НЕ ПустаяСтрока(ОписаниеПанелиВычеты.ТабличнаяЧастьНДФЛ.ИмяПоляПериод) Тогда
		ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(
			ДанныеНДФЛСтроки,
			ОписаниеПанелиВычеты.ТабличнаяЧастьНДФЛ.ИмяПоляПериод,
			ОписаниеПанелиВычеты.ТабличнаяЧастьНДФЛ.ИмяПоляПериод + "Строкой");
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти


#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура СведенияОДоходахПриСозданииНаСервере(Форма, КодДоходаПутьКДанным, ИмяПоляКодВычета, ИмяПоляСуммаВычета = "") Экспорт 	
	УстановитьУсловноеОформлениеТаблицыСведенияОДоходах(Форма, КодДоходаПутьКДанным, ИмяПоляКодВычета, ИмяПоляСуммаВычета);
КонецПроцедуры	

Процедура УстановитьУсловноеОформлениеТаблицыСведенияОДоходах(Форма, КодДоходаПутьКДанным, ИмяПоляКодВычета, ИмяПоляСуммаВычета)
	
	БудущийНалоговыйПериод = Год(ТекущаяДатаСеанса()) + 1;
	
	СоответствиеДоходов = Новый Соответствие;
	Для СчЛет = 2010 По БудущийНалоговыйПериод Цикл
		СоответствиеНалоговогоПериода = УчетНДФЛ.ВычетыКДоходам(СчЛет);
		Для каждого Элемент Из СоответствиеНалоговогоПериода Цикл
			СоответствиеДоходов.Вставить(Элемент.Ключ, Истина);
		КонецЦикла;
	КонецЦикла;
	СписокДоходовСВычетами = Новый СписокЗначений;
	Для каждого Элемент Из СоответствиеДоходов Цикл
		СписокДоходовСВычетами.Добавить(Элемент.Ключ);
	КонецЦикла;
	
	ЭлементУсловногоОформления = Форма.УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Использование = Истина;
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(КодДоходаПутьКДанным);
	ЭлементОтбора.ПравоеЗначение = СписокДоходовСВычетами;
	
	ОформляемоеПоле =  ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(ИмяПоляКодВычета);
	
	Если ИмяПоляСуммаВычета <> "" Тогда 
		ОформляемоеПоле =  ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ОформляемоеПоле.Использование = Истина;
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(ИмяПоляСуммаВычета);
	КонецЕсли;
	
	ЭлементОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("ТолькоПросмотр");
	ЭлементОформления.Использование = Истина;
	ЭлементОформления.Значение = Истина;
	
КонецПроцедуры	

Процедура СправкиНДФЛУстановитьСписокВыбораРегистрацийВНО(Форма, ФизическоеЛицо = Неопределено) Экспорт 

КонецПроцедуры	

Процедура СправкиНДФЛУстановитьЗаголовокПоляРегистрацияВНО(Форма) Экспорт
	Если УчетНДФЛКлиентСервер.СправкиНДФЛДокументИспользуетКодОКТМО(Форма.Объект) Тогда	
		Заголовок = "ОКТМО/КПП";		
	Иначе	
		Заголовок = "ОКАТО/КПП";
	КонецЕсли;	
	
	ТекущийЗаголовок = ОбщегоНазначенияКлиентСервер.ЗначениеСвойстваЭлементаФормы(Форма.Элементы, "РегистрацияВНалоговомОргане", "Заголовок");
	
	Если ТекущийЗаголовок <> Заголовок Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "РегистрацияВНалоговомОргане", "Заголовок", Заголовок);
	КонецЕсли;	
КонецПроцедуры	

Процедура СправкиНДФЛЗафиксироватьДанныеСотрудников(ДанныеСправок) Экспорт
	ФиксируемыеПоля = УчетНДФЛКлиентСервер.СправкиНДФЛИменаФиксируемыхПолей();
	
	Для Каждого СправкаПоСотруднику Из ДанныеСправок Цикл
		Для Каждого ИмяПоля Из ФиксируемыеПоля Цикл
			СправкаПоСотруднику["Фикс" + ИмяПоля] = Истина;	
		КонецЦикла;	
		
		СправкаПоСотруднику.ФиксНалоги = Истина;
		СправкаПоСотруднику.ФиксУведомление = Истина;
	КонецЦикла;	
КонецПроцедуры	

Процедура ПрочитатьИННвСтранеГражданства(МенеджерВременныхТаблиц, Сотрудники, Дата)

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ГражданствоФизическихЛицСрезПоследних.ИНН КАК ИННвСтранеГражданства,
	|	ГражданствоФизическихЛицСрезПоследних.ФизическоеЛицо
	|ПОМЕСТИТЬ ВТИННвСтранеГражданства
	|ИЗ
	|	РегистрСведений.ГражданствоФизическихЛиц.СрезПоследних(&Дата, ) КАК ГражданствоФизическихЛицСрезПоследних
	|ГДЕ
	|	ГражданствоФизическихЛицСрезПоследних.ФизическоеЛицо В(&Сотрудники)";
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура СправкиНДФЛПрочитатьДанныеСотрудников(ДанныеСправок, НалоговыйПериод, ДатаДокумента, ОбновлятьНеФиксированныеДанные = Истина) Экспорт
	ЗаполняемыеПоля = УчетНДФЛКлиентСервер.СправкиНДФЛИменаФиксируемыхПолей();	
	
	СотрудникиДляЗаполнения = Новый Массив;
	ДанныеСправокПоСотрудникам = Новый Соответствие;
	
	Для Каждого ДанныеСправкиПоСотруднику Из ДанныеСправок Цикл
		
		Если СотрудникиДляЗаполнения.Найти(ДанныеСправкиПоСотруднику.Сотрудник) = Неопределено Тогда
		
			ПолучатьКадровыеДанныеСотрудника = Ложь;
			Если ОбновлятьНеФиксированныеДанные Тогда
				Для Каждого ИмяПоля Из ЗаполняемыеПоля Цикл
					Если Не ДанныеСправкиПоСотруднику["Фикс" + ИмяПоля] Тогда 
						ПолучатьКадровыеДанныеСотрудника = Истина;	
					КонецЕсли;			
				КонецЦикла;	
			КонецЕсли;
			
			Если ПолучатьКадровыеДанныеСотрудника Тогда
				СотрудникиДляЗаполнения.Добавить(ДанныеСправкиПоСотруднику.Сотрудник);			
				ДанныеСправокПоСотрудникам.Вставить(ДанныеСправкиПоСотруднику.Сотрудник, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеСправкиПоСотруднику));
			КонецЕсли;
		
		Иначе
			ДанныеСправокПоСотрудникам[ДанныеСправкиПоСотруднику.Сотрудник].Добавить(ДанныеСправкиПоСотруднику)
		КонецЕсли;
		
	КонецЦикла;	
	
	Если СотрудникиДляЗаполнения.Количество() > 0 Тогда
				
		НеобходимыеКадровыеДанные = Новый Массив();
		
		НеобходимыеКадровыеДанные.Добавить("ФизическоеЛицо");
		НеобходимыеКадровыеДанные.Добавить("Фамилия");
		НеобходимыеКадровыеДанные.Добавить("Наименование");
		НеобходимыеКадровыеДанные.Добавить("Имя");
		НеобходимыеКадровыеДанные.Добавить("Отчество");
		НеобходимыеКадровыеДанные.Добавить("ДокументВид");
		НеобходимыеКадровыеДанные.Добавить("ДокументСерия");
		НеобходимыеКадровыеДанные.Добавить("ДокументНомер");
		НеобходимыеКадровыеДанные.Добавить("ДатаРождения");	
		НеобходимыеКадровыеДанные.Добавить("Страна");
		НеобходимыеКадровыеДанные.Добавить("ИНН");
		НеобходимыеКадровыеДанные.Добавить("АдресЗаПределамиРФ");
		НеобходимыеКадровыеДанные.Добавить("АдресЗаПределамиРФПредставление");
		НеобходимыеКадровыеДанные.Добавить("АдресПоПрописке");
		НеобходимыеКадровыеДанные.Добавить("АдресПоПропискеПредставление");
		
		МенеджерВТ = Новый МенеджерВременныхТаблиц;
		
		КадровыйУчет.СоздатьНаДатуВТКадровыеДанныеФизическихЛиц(МенеджерВТ, Истина, СотрудникиДляЗаполнения, НеобходимыеКадровыеДанные, ДатаДокумента);
		ПрочитатьИННвСтранеГражданства(МенеджерВТ, СотрудникиДляЗаполнения, ДатаДокумента);
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	КадровыеДанныеФизЛиц.АдресПоПропискеПредставление КАК АдресПредставление,
		|	КадровыеДанныеФизЛиц.АдресЗаПределамиРФПредставление КАК АдресЗарубежомПредставление,
		|	КадровыеДанныеФизЛиц.АдресПоПрописке КАК Адрес,
		|	КадровыеДанныеФизЛиц.АдресЗаПределамиРФ КАК АдресЗарубежом,
		|	КадровыеДанныеФизЛиц.Фамилия КАК Фамилия,
		|	КадровыеДанныеФизЛиц.Имя КАК Имя,
		|	КадровыеДанныеФизЛиц.Отчество КАК Отчество,
		|	КадровыеДанныеФизЛиц.ДатаРождения КАК ДатаРождения,
		|	ЕСТЬNULL(КадровыеДанныеФизЛиц.Страна, ЗНАЧЕНИЕ(Справочник.СтраныМира.Россия)) КАК Гражданство,
		|	КадровыеДанныеФизЛиц.ДокументВид КАК ВидДокумента,
		|	КадровыеДанныеФизЛиц.ДокументСерия КАК СерияДокумента,
		|	КадровыеДанныеФизЛиц.ДокументНомер КАК НомерДокумента,
		|	КадровыеДанныеФизЛиц.ИНН КАК ИНН,
		|	КадровыеДанныеФизЛиц.ФизическоеЛицо
		|ПОМЕСТИТЬ ВТТекущиеДанныеФизЛиц
		|ИЗ
		|	ВТКадровыеДанныеФизическихЛиц КАК КадровыеДанныеФизЛиц
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТКадровыеДанныеФизическихЛиц
		|";	
		
		Запрос.Выполнить();
		
		КадровыйУчет.СоздатьНаДатуВТКадровыеДанныеФизическихЛиц(МенеджерВТ, Истина, СотрудникиДляЗаполнения, "СтатусНалогоплательщика", КонецГода(Дата(НалоговыйПериод, 1, 1)));
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТекущиеДанныеФизЛиц.Адрес КАК Адрес,
		|	ТекущиеДанныеФизЛиц.АдресЗарубежом КАК АдресЗарубежом,
		|	ТекущиеДанныеФизЛиц.Фамилия КАК Фамилия,
		|	ТекущиеДанныеФизЛиц.Имя КАК Имя,
		|	ТекущиеДанныеФизЛиц.Отчество КАК Отчество,
		|	ТекущиеДанныеФизЛиц.ДатаРождения КАК ДатаРождения,
		|	ТекущиеДанныеФизЛиц.Гражданство КАК Гражданство,
		|	ЕСТЬNULL(ИННывСтранеГражданства.ИННвСтранеГражданства, """") КАК ИННвСтранеГражданства,
		|	ТекущиеДанныеФизЛиц.ВидДокумента КАК ВидДокумента,
		|	ТекущиеДанныеФизЛиц.СерияДокумента КАК СерияДокумента,
		|	ТекущиеДанныеФизЛиц.НомерДокумента КАК НомерДокумента,
		|	ТекущиеДанныеФизЛиц.ИНН КАК ИНН,
		|	СтатусыФизЛицНаКонецГода.СтатусНалогоплательщика КАК СтатусНалогоплательщика,
		|	ТекущиеДанныеФизЛиц.ФизическоеЛицо КАК ФизическоеЛицо
		|ИЗ
		|	ВТТекущиеДанныеФизЛиц КАК ТекущиеДанныеФизЛиц
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК СтатусыФизЛицНаКонецГода
		|		ПО ТекущиеДанныеФизЛиц.ФизическоеЛицо = СтатусыФизЛицНаКонецГода.ФизическоеЛицо
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТИННвСтранеГражданства КАК ИННывСтранеГражданства
		|		ПО ТекущиеДанныеФизЛиц.ФизическоеЛицо = ИННывСтранеГражданства.ФизическоеЛицо";

		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			ДанныеСправокПоСотруднику = ДанныеСправокПоСотрудникам[Выборка.ФизическоеЛицо];
			
			Для каждого ДанныеСправкиПоСотруднику Из ДанныеСправокПоСотруднику Цикл
				Для Каждого ИмяПоля Из ЗаполняемыеПоля Цикл
					Если НЕ ДанныеСправкиПоСотруднику["Фикс" + ИмяПоля] Тогда 
						ДанныеСправкиПоСотруднику[ИмяПоля] = Выборка[ИмяПоля];
						Если ИмяПоля = "Гражданство" И ДанныеСправкиПоСотруднику.Свойство("ИННвСтранеГражданства") Тогда
							ДанныеСправкиПоСотруднику.ИННвСтранеГражданства = Выборка.ИННвСтранеГражданства;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;	
			КонецЦикла;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры	

Процедура СправкиНДФЛОтменитьИсправлениеДанныхСотрудника(Форма, СправкаПоСотруднику,НалоговыйПериод, ДатаДокумента) Экспорт
														
	ЗаполняемыеПоля = УчетНДФЛКлиентСервер.СправкиНДФЛИменаФиксируемыхПолей();	
	
	ЧитатьДанныеСотрудников = Ложь;
	Для Каждого ИмяПоля Из ЗаполняемыеПоля Цикл
		ЧитатьДанныеСотрудников = ЧитатьДанныеСотрудников Или СправкаПоСотруднику["Фикс" + ИмяПоля];
		
		СправкаПоСотруднику["Фикс" + ИмяПоля] = Ложь; 
	КонецЦикла;	
	
	Если ЧитатьДанныеСотрудников Тогда
		ДанныеСправок = Новый Массив;
		ДанныеСправок.Добавить(СправкаПоСотруднику);
		
		СправкиНДФЛПрочитатьДанныеСотрудников(ДанныеСправок, НалоговыйПериод, ДатаДокумента, Истина);
		
		УчетНДФЛКлиентСервер.СправкиНДФЛУстановитьСвойстваЭлементовСФиксациейДанных(Форма, СправкаПоСотруднику, Форма.ДокументПроведен);
	КонецЕсли;	
		
	УчетНДФЛКлиентСервер.СправкиНДФЛУстановитьИнфонадписьИсправления(Форма.ИнфоНадписьИсправления, СправкаПоСотруднику, Форма.ДокументПроведен);
	УчетНДФЛКлиентСервер.СправкиНДФЛУстановитьСвойстваЭлементовСФиксациейДанных(Форма, СправкаПоСотруднику, Форма.ДокументПроведен);
		
КонецПроцедуры	

Процедура СправкиНДФЛОбновитьНалоги(Форма, СправкаПоСотруднику, СведенияОДоходах, СведенияОВычетах, НалоговыйПериод, ДатаДокумента, Организация, РегистрацияВНалоговомОргане, ИспользоватьНомераСправок, ЗаполнятьБезДоходовПоЦеннымБумагам = Ложь, УведомленияНОоПравеНаВычеты = Неопределено) Экспорт
								
	СправкаПоСотруднику.ФиксНалоги = Ложь;
		
	ДанныеСправок = Новый Массив;
	ДанныеСправок.Добавить(СправкаПоСотруднику);
	
	СправкиНДФЛПрочитатьДанныеОДоходахИНалогах(ДанныеСправок, 
										СведенияОДоходах, 
										СведенияОВычетах, 
										НалоговыйПериод, 
										ДатаДокумента, 
										Организация, 
										РегистрацияВНалоговомОргане, 
										ИспользоватьНомераСправок, 
										ЗаполнятьБезДоходовПоЦеннымБумагам,
										УведомленияНОоПравеНаВычеты);
										
	СправкаПоСотруднику.ФиксУведомление = Ложь;
	
	ДанныеСправок = Новый Массив;
	ДанныеСправок.Добавить(СправкаПоСотруднику);
	
	
КонецПроцедуры	

Процедура СправкиНДФЛПрочитатьДанныеОДоходахИНалогах(ДанныеСправок, СведенияОДоходах, СведенияОВычетах, НалоговыйПериод, ДатаДокумента, Организация, РегистрацияВНалоговомОргане = Неопределено, ИспользоватьНомераСправок = Истина, ЗаполнятьБезДоходовПоЦеннымБумагам = Ложь, УведомленияНОоПравеНаВычеты = Неопределено) Экспорт
								
	
КонецПроцедуры	

Процедура СправкиНДФЛПрочитатьДанные(ДанныеСправок, СведенияОДоходах, СведенияОВычетах, НалоговыйПериод, ДатаДокумента, Организация,  РегистрацияВНалоговомОргане = Неопределено, ИспользоватьНомераСправок = Истина, ОбновлятьНеФиксированныеДанные = Истина, ЗаполнятьБезДоходовПоЦеннымБумагам = Ложь, УведомленияНОоПравеНаВычеты = Неопределено, НомерКорректировки = 0) Экспорт
																	
	СправкиНДФЛПрочитатьДанныеСотрудников(ДанныеСправок, НалоговыйПериод, ДатаДокумента, ОбновлятьНеФиксированныеДанные);
	
	Если НомерКорректировки = 99 Тогда
		Возврат
	КонецЕсли;
	
	СправкиСНефиксированнымиСведениямиОНалогах = Новый Массив;
	Для Каждого ДанныеСправкиПоСотруднику Из ДанныеСправок Цикл
		Если Не ДанныеСправкиПоСотруднику.ФиксНалоги Тогда
			СправкиСНефиксированнымиСведениямиОНалогах.Добавить(ДанныеСправкиПоСотруднику);
		КонецЕсли;	
	КонецЦикла;	
	
	СправкиНДФЛПрочитатьДанныеОДоходахИНалогах(СправкиСНефиксированнымиСведениямиОНалогах, 
										    СведенияОДоходах, 
										    СведенияОВычетах, 
											НалоговыйПериод, 
											ДатаДокумента, 
											Организация, 
											РегистрацияВНалоговомОргане, 
											ИспользоватьНомераСправок, 
											ЗаполнятьБезДоходовПоЦеннымБумагам,
											УведомленияНОоПравеНаВычеты);
	
КонецПроцедуры									


Процедура СправкиНДФЛОбновитьИтоги(ДанныеСправки, СведенияОДоходах, СведенияОВычетах) Экспорт	
	
КонецПроцедуры	
//		Возврат "";
//КонецФункции	

//Процедура СправкиНДФЛУстановитьПредставлениеРегистрацииВНО(Форма) Экспорт 
//	Форма.РегистрацияВНОПредставление = СправкиНДФЛПредставлениеРегистрацииВНО(Форма, Форма.Объект.РегистрацияВНалоговомОргане);
//КонецПроцедуры	
//-- НЕУКР

Процедура СправкаНДФЛУстановитьИнофнадписьОписаниеДоходовОрганизации(Форма, СводнаяСправка = Ложь, ФизическоеЛицо = Неопределено, ДляНалогаНаПрибыль = Ложь, НеВключатьДоходыПоЦеннымБумагам = Ложь) Экспорт

КонецПроцедуры	

Процедура СправкиНДФЛОчиститьДанныеСправки(ДанныеСправки, ДляНалогаНаПрибыль = Ложь) Экспорт
	
КонецПроцедуры	

Процедура СправкиНДФЛЗаполнитьСписокКонтролируемыхПолей(Форма, ДляНалогаНаПрибыль = Ложь) Экспорт
	
КонецПроцедуры	

Функция ПоместитьДанныеСправки2НДФЛВХранилище(Форма, ДанныеСотрудника, СтрокиСведенийОДоходах, СтрокиСведенийОВычетах, НомерСправки, Ошибки = Неопределено, НоваяСтрока = Ложь, Ставка = Неопределено, НеВключатьДоходыПоЦеннымБумагам = Ложь, УведомленияНОоПравеНаВычеты = Неопределено) Экспорт
		
КонецФункции

Процедура ПроверитьЗанятостьПолучателяВычетов(Организация, Месяц, Сотрудники, Отказ) Экспорт
	
	УчетНДФЛФормыВнутренний.ПроверитьЗанятостьПолучателяВычетов(Организация, Месяц, Сотрудники, Отказ);
	
КонецПроцедуры


#Область ПанельПримененныеВычеты

Процедура ЗаполнитьПредставлениеВычетовНаДетейИИмущественныхСтрокиНДФЛ(Форма, СтрокаНДФЛ, ОписаниеПанелиВычеты)
	
	ВычетыНаДетейИИмущественные = ОписаниеПанелиВычеты.НастраиваемыеПанели.Получить("ВычетыНаДетейИИмущественные");
	Если ВычетыНаДетейИИмущественные <> Неопределено Тогда
		
		СтрокаНДФЛ.ПредставлениеВычетовНаДетейИИмущественных = 0;
		ДанныеВычетовНаДетейИИмущественных = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
			Форма, ВычетыНаДетейИИмущественные);
			
		ДанныеПоСтрокеНДФЛ = ДанныеВычетовНаДетейИИмущественных.НайтиСтроки(Новый Структура("ИдентификаторСтрокиНДФЛ", СтрокаНДФЛ.ИдентификаторСтрокиНДФЛ));
		Для каждого СтрокаДанныхВычетов Из ДанныеПоСтрокеНДФЛ Цикл
			УчетНДФЛКлиентСервер.ДополнитьПредставлениеВычетов(СтрокаНДФЛ.ПредставлениеВычетовНаДетейИИмущественных, СтрокаДанныхВычетов.КодВычета, СтрокаДанныхВычетов.РазмерВычета);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПредставлениеВычетовКДоходамСтрокиНДФЛ(Форма, СтрокаНДФЛ, ОписаниеПанелиВычеты)
	
	ВычетыКДоходам = ОписаниеПанелиВычеты.НастраиваемыеПанели.Получить("ВычетыКДоходам");
	Если ВычетыКДоходам <> Неопределено Тогда
		
		СтрокаНДФЛ.ПредставлениеВычетовКДоходам = 0;
		
		ДанныеВычетовКДоходам = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
			Форма, ВычетыКДоходам);
			
		СтруктураОтбораВычетыПримененныеКДоходам = Новый Структура("ФизическоеЛицо,Подразделение,ВычетПримененныйКДоходам");
		ЗаполнитьЗначенияСвойств(СтруктураОтбораВычетыПримененныеКДоходам, СтрокаНДФЛ);
		
		СтруктураОтбораВычетыПримененныеКДоходам.ВычетПримененныйКДоходам = Истина;
		
		ДанныеПоСтрокеНДФЛ = ДанныеВычетовКДоходам.НайтиСтроки(СтруктураОтбораВычетыПримененныеКДоходам);
		Для каждого СтрокаДанныхВычетов Из ДанныеПоСтрокеНДФЛ Цикл
			УчетНДФЛКлиентСервер.ДополнитьПредставлениеВычетов(СтрокаНДФЛ.ПредставлениеВычетовКДоходам, СтрокаДанныхВычетов.КодВычета, СтрокаДанныхВычетов.СуммаВычета);
		КонецЦикла;
		
	КонецЕсли; 
			
КонецПроцедуры

Процедура ЗаполнитьПредставленияВычетовСтрокиНДФЛ(Форма, СтрокаНДФЛ, ОписаниеПанелиВычеты) Экспорт
	
	УчетНДФЛКлиентСервер.ЗаполнитьПредставлениеВычетовЛичныхСтрокиНДФЛ(Форма, СтрокаНДФЛ, ОписаниеПанелиВычеты);
	ЗаполнитьПредставлениеВычетовНаДетейИИмущественныхСтрокиНДФЛ(Форма, СтрокаНДФЛ, ОписаниеПанелиВычеты);
	ЗаполнитьПредставлениеВычетовКДоходамСтрокиНДФЛ(Форма, СтрокаНДФЛ, ОписаниеПанелиВычеты);
		
КонецПроцедуры

Процедура ОбновитьПредставлениеВычетовНаДетейИИмущественныхСтрокиНДФЛ(Форма) Экспорт
	
	ОписаниеПанелиВычеты = Форма.ОписаниеПанелиВычетыНаСервере();
	Если ОписаниеПанелиВычеты.НастраиваемыеПанели.Получить("ВычетыНаДетейИИмущественные") <> Неопределено Тогда
		
		НДФЛТекущиеДанные = УчетНДФЛКлиентСервер.НДФЛТекущиеДанные(Форма, ОписаниеПанелиВычеты);
		ЗаполнитьПредставлениеВычетовНаДетейИИмущественныхСтрокиНДФЛ(Форма, НДФЛТекущиеДанные, ОписаниеПанелиВычеты);
		
		Форма[ОписаниеПанелиВычеты.ИмяГруппыФормыПанелиВычеты + "ПредставлениеВычетовНаДетейИИмущественных"] = НДФЛТекущиеДанные["ПредставлениеВычетовНаДетейИИмущественных"];
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьПредставлениеВычетовКДоходамСтрокиНДФЛ(Форма) Экспорт
	
	ОписаниеПанелиВычеты = Форма.ОписаниеПанелиВычетыНаСервере();
	Если ОписаниеПанелиВычеты.НастраиваемыеПанели.Получить("ВычетыКДоходам") <> Неопределено Тогда
		
		НДФЛТекущиеДанные = УчетНДФЛКлиентСервер.НДФЛТекущиеДанные(Форма, ОписаниеПанелиВычеты);
		ЗаполнитьПредставлениеВычетовКДоходамСтрокиНДФЛ(Форма, НДФЛТекущиеДанные, ОписаниеПанелиВычеты);
		
		Форма[ОписаниеПанелиВычеты.ИмяГруппыФормыПанелиВычеты + "ПредставлениеВычетовКДоходам"] = НДФЛТекущиеДанные["ПредставлениеВычетовКДоходам"];
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура УстановитьФиксРасчетСтрокНДФЛ(Форма, СтруктураПоиска) Экспорт
	
	УчетНДФЛФормыВнутренний.УстановитьФиксРасчетСтрокНДФЛ(Форма, СтруктураПоиска);
	
КонецПроцедуры

Функция ФормаПодробнееОРасчетеНДФЛКонтролируемыеПоляДляФиксацииРезультатов() Экспорт
	
	Возврат УчетНДФЛФормыВнутренний.ФормаПодробнееОРасчетеНДФЛКонтролируемыеПоляДляФиксацииРезультатов();
	
КонецФункции

#КонецОбласти


Функция СведенияОбНДФЛ(Форма, ФизическоеЛицо = Неопределено, ПутьКДаннымАдресРаспределенияРезультатовВХранилище = Неопределено, ТаблицаНачислений= Неопределено) Экспорт
	
	ДанныеОбНДФЛ = Новый Структура;
	Если ФизическоеЛицо = Неопределено Тогда
		
		КоллекцияСтрокНДФЛ = Форма.Объект.НДФЛ.Выгрузить();
		КоллекцияСтрокПримененныхВычетовНаДетейИИмущественных = Форма.Объект.ПримененныеВычетыНаДетейИИмущественные.Выгрузить();
		
		Если ТаблицаНачислений <> Неопределено Тогда
			ДанныеОбНДФЛ.Вставить("Начисления", ТаблицаНачислений);
		КонецЕсли; 
		
	Иначе
		
		СтруктураОтбора = Новый Структура("ФизическоеЛицо", ФизическоеЛицо);
		КоллекцияСтрокНДФЛ = Форма.Объект.НДФЛ.Выгрузить(СтруктураОтбора);
		
		Если Форма.Объект.ПримененныеВычетыНаДетейИИмущественные.Количество() = 0 Тогда
			КоллекцияСтрокПримененныхВычетовНаДетейИИмущественных =	Форма.Объект.ПримененныеВычетыНаДетейИИмущественные.Выгрузить();
		Иначе
			
			КоллекцияСтрокПримененныхВычетовНаДетейИИмущественных =	Форма.Объект.ПримененныеВычетыНаДетейИИмущественные.Выгрузить(
				ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Форма.Объект.ПримененныеВычетыНаДетейИИмущественные[0]));
				
			КоллекцияСтрокПримененныхВычетовНаДетейИИмущественных.Очистить();
			
			ИдентификаторыСтрокНДФЛ = Новый Соответствие;
			Для каждого СтрокаНДФЛ Из КоллекцияСтрокНДФЛ Цикл
				ИдентификаторыСтрокНДФЛ.Вставить(СтрокаНДФЛ.ИдентификаторСтрокиНДФЛ, Истина);
			КонецЦикла;
			
			Для каждого СтрокаВычетов Из Форма.Объект.ПримененныеВычетыНаДетейИИмущественные Цикл
				
				Если ИдентификаторыСтрокНДФЛ.Получить(СтрокаВычетов.ИдентификаторСтрокиНДФЛ) = Истина Тогда
					ЗаполнитьЗначенияСвойств(КоллекцияСтрокПримененныхВычетовНаДетейИИмущественных.Добавить(), СтрокаВычетов);
				КонецЕсли; 
				
			КонецЦикла;
		
		КонецЕсли;
		
		СтруктураОтбора.Вставить("ВычетПримененныйКДоходам", Истина);
		ДанныеОбНДФЛ.Вставить("Начисления", Форма.Объект.Начисления.Выгрузить(СтруктураОтбора));
		
	КонецЕсли;
	
	ДанныеОбНДФЛ.Вставить("НДФЛ", КоллекцияСтрокНДФЛ);
	ДанныеОбНДФЛ.Вставить("ПримененныеВычетыНаДетейИИмущественные", КоллекцияСтрокПримененныхВычетовНаДетейИИмущественных);
	
	Если ПутьКДаннымАдресРаспределенияРезультатовВХранилище <> Неопределено Тогда
		ДанныеОбНДФЛ.Вставить("АдресРаспределенияРезультатовВХранилище", Форма[ПутьКДаннымАдресРаспределенияРезультатовВХранилище]);
	КонецЕсли; 
	
	Возврат ПоместитьВоВременноеХранилище(ДанныеОбНДФЛ, Форма.УникальныйИдентификатор);
	
КонецФункции

Процедура ФормаПодробнееОРасчетеНДФЛПриЗаполнении(Форма, ОписаниеТаблицыНДФЛ, ОписанияТаблицДляРаспределения) Экспорт
	
	УчетНДФЛФормыВнутренний.ФормаПодробнееОРасчетеНДФЛПриЗаполнении(Форма, ОписаниеТаблицыНДФЛ, ОписанияТаблицДляРаспределения);
	
КонецПроцедуры

#КонецОбласти
