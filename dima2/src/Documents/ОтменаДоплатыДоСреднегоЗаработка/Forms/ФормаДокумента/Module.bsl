
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура(
			"Организация, Ответственный", "Объект.Организация", "Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		ПриПолученииДанныхНаСервере();
		
		РасчетЗарплатыРасширенныйФормы.ЗаполнитьНачислениеВФормеДокументаПоКатегории(
			ЭтаФорма, Объект.Начисление, Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДоплатаДоСреднегоЗаработка);
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьПараметрыВыбораСотрудников(ЭтаФорма, "Сотрудник");
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Если ЗначениеЗаполнено(Объект.ИсправленныйДокумент) Тогда
		Оповестить("ИсправленДокумент", , Объект.ИсправленныйДокумент);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ДанныеВРеквизиты();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыНачисления" И Источник = ЭтаФорма Тогда
		ЗаполнитьНачисленияИзВРеменногоХранилища(Параметр.АдресВХранилище);
	ИначеЕсли ИмяСобытия = "ИсправленДокумент" И Источник = Объект.Ссылка Тогда
		ДанныеВРеквизиты();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ПриИзмененииРеквизитовОпределяющихОграниченияНаУровнеЗаписей();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	СотрудникПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОтменыПриИзменении(Элемент)
	
	ДатаОтменыПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	ДокументОснованиеПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИзменитьФОТНажатие(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("АдресВХранилище", АдресВХранилищеНачисленийИУдержаний(Объект.Сотрудник));
		ПараметрыОткрытия.Вставить("ТолькоПросмотр", ТолькоПросмотр);
		
		ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуРедактированияСоставаНачисленийИУдержаний(ПараметрыОткрытия, ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОтменаДоплатыУтвержденаПриИзменении(Элемент)
	ОтменаДоплатыУтвержденаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОтменаДоплатыУтвержденаПриИзмененииНаСервере()
	ЗарплатаКадрыРасширенный.УстановитьПредупреждающуюНадписьВМногофункциональныхДокументах(ЭтаФорма, "ОтменаДоплатыУтверждена");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьДокументыВведенныеПозже(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьВведенныеНаДатуДокументы(ЭтотОбъект.ДокументыВведенныеПозже);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьРанееВведенныеДокументы(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьВведенныеНаДатуДокументы(ЭтотОбъект.РанееВведенныеДокументы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// ИсправлениеДокументов
&НаКлиенте
Процедура Подключаемый_Исправить(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.Исправить(Объект.Ссылка, "ОтменаДоплатыДоСреднегоЗаработка");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправлению(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправлению(ЭтаФорма.ДокументИсправление, "ОтменаДоплатыДоСреднегоЗаработка");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправленному(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправленному(Объект.ИсправленныйДокумент, "ОтменаДоплатыДоСреднегоЗаработка");
КонецПроцедуры
// Конец ИсправлениеДокументов

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки 

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОписаниеТаблицыВидовРасчета = ОписаниеТаблицыНачислений();
	ЗарплатаКадрыРасширенный.РедактированиеСоставаНачисленийДополнитьФорму(ЭтаФорма, ОписаниеТаблицыВидовРасчета, "Начисления", 1, Ложь);
	
	ЗарплатаКадрыРасширенный.ОформлениеНесколькихДокументовНаОднуДатуДополнитьФорму(ЭтотОбъект);
	
	ИсправлениеДокументовЗарплатаКадры.ГруппаИсправлениеДополнитьФорму(ЭтаФорма, Истина, Ложь);
	
	ДанныеВРеквизиты();
	
КонецПроцедуры

&НаСервере
Процедура ДанныеВРеквизиты()
	
	УстановитьДоступностьРегистрацииНачислений();
	
	ИспользуетсяРасчетЗарплаты = ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная");
	
	ПрочитатьВремяРегистрации();
	
	ЗарплатаКадрыРасширенный.МногофункциональныеДокументыДобавитьЭлементыФормы(
		ЭтаФорма, НСтр("ru='Отмена доплаты утверждена';uk='Скасування доплати затверджена'"), , "ОтменаДоплатыУтверждена");
	
	ЗарплатаКадрыРасширенный.УстановитьПредупреждающуюНадписьВМногофункциональныхДокументах(ЭтаФорма, "ОтменаДоплатыУтверждена");
	
	Если ИспользуетсяРасчетЗарплаты И Не ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений И Объект.ОтменаДоплатыУтверждена Тогда 
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	УстановитьВидимостьРасчетныхПолей();
	
	Если ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений Тогда 
		РассчитатьФОТНаФорме(ЭтаФорма);
	КонецЕсли;
	
	Если Не ЭтаФорма.Параметры.Ключ.Пустая() Тогда
		ИсправлениеДокументовЗарплатаКадры.ПрочитатьРеквизитыИсправления(ЭтаФорма, "ПериодическиеСведения");
	КонецЕсли;
	ИсправлениеДокументовЗарплатаКадры.УстановитьПоляИсправления(ЭтаФорма, "ПериодическиеСведения");
	
	УстановитьОтображениеНадписей();
	
КонецПроцедуры

&НаСервере
Процедура ДокументОснованиеПриИзмененииНаСервере()
	Объект.Начисление = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ДокументОснование, "Начисление");
	ЗаполнитьНачисленияСотрудника();
	РассчитатьФОТПоДокументу();
КонецПроцедуры

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	
	ПриИзмененииРеквизитовОпределяющихОграниченияНаУровнеЗаписей();
	
	ЗаполнитьНачисленияСотрудника();
	РассчитатьФОТПоДокументу();
	
	УстановитьОтображениеНадписей();
	
КонецПроцедуры

&НаСервере
Процедура ДатаОтменыПриИзмененииНаСервере()
	ПрочитатьВремяРегистрации();
	ЗаполнитьНачисленияСотрудника();
	РассчитатьФОТПоДокументу();
	УстановитьОтображениеНадписей();
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьРасчетныхПолей()
	
	ИменаЭлементов = Новый Массив;
	ИменаЭлементов.Добавить("ГруппаФОТ");
	
	ЗарплатаКадрыРасширенный.УстановитьОтображениеПолейМногофункциональныхДокументов(ЭтаФорма, ИменаЭлементов);
	
	Если ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений Тогда 
		ЗарплатаКадрыРасширенный.УстановитьОтображениеГруппыФормы(Элементы, "ГруппаФОТ", "ТолькоПросмотр", Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьРегистрацииНачислений()
	
	ПраваНаДокумент = ЗарплатаКадрыРасширенный.ПраваНаМногофункциональныйДокумент(Объект);
	РегистрацияНачисленийДоступна = ПраваНаДокумент.ПолныеПраваПоРолям;
	ОграниченияНаУровнеЗаписей = Новый ФиксированнаяСтруктура(ПраваНаДокумент.ОграниченияНаУровнеЗаписей);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРеквизитовОпределяющихОграниченияНаУровнеЗаписей()
	
	БылиОграничения = ОграниченияНаУровнеЗаписей;
	УстановитьДоступностьРегистрацииНачислений();
	
	Если БылиОграничения.ЧтениеБезОграничений <> ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений
		Или БылиОграничения.ИзменениеБезОграничений <> ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений
		Или БылиОграничения.ИзменениеКадровыхДанных <> ОграниченияНаУровнеЗаписей.ИзменениеКадровыхДанных Тогда 
		
		Объект.ОтменаДоплатыУтверждена = ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений;
		
		УстановитьВидимостьРасчетныхПолей();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеТаблицыНачислений()
	
	ОписаниеТаблицыВидовРасчета = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	ОписаниеТаблицыВидовРасчета.ПутьКДанным = "Объект.НачисленияСотрудника";
	ОписаниеТаблицыВидовРасчета.ПутьКДаннымПоказателей = "";
	ОписаниеТаблицыВидовРасчета.ИмяРеквизитаДокументОснование = "ДокументОснование";
	
	Возврат ОписаниеТаблицыВидовРасчета;	
	
КонецФункции	

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьФОТНаФорме(Форма)
	Форма.ФОТ = Форма.Объект.НачисленияСотрудника.Итог("Размер");
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачисленияСотрудника()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Объект.НачисленияСотрудника.Очистить();
	
	СотрудникиДаты = Новый ТаблицаЗначений;
	СотрудникиДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	СотрудникиДаты.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	НоваяСтрока = СотрудникиДаты.Добавить();
	НоваяСтрока.Сотрудник = Объект.Сотрудник;
	НоваяСтрока.Период = ВремяРегистрации;
	
	ТаблицаНачислений = РасчетЗарплатыРасширенный.ДействующиеПлановыеНачисления(СотрудникиДаты, Объект.Ссылка);
	
	СтрокиДоплаты = ТаблицаНачислений.НайтиСтроки(Новый Структура("Начисление", Объект.Начисление));
	Для Каждого СтрокаДоплаты Из СтрокиДоплаты Цикл
		ТаблицаНачислений.Удалить(СтрокаДоплаты);
	КонецЦикла;
	
	Объект.НачисленияСотрудника.Загрузить(ТаблицаНачислений);
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьФОТПоДокументу()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Объект.Организация) 
		Или Не ЗначениеЗаполнено(Объект.Сотрудник) 
		Или Не ЗначениеЗаполнено(Объект.ДатаОтмены) Тогда
		Возврат;
	КонецЕсли;
	
	// Подготовка к расчету ФОТ
	РассчитываемыеОбъекты = Новый Соответствие;
	
	Сотрудники = Новый Соответствие;
	
	ОписаниеСотрудника = Новый Структура;
	ОписаниеСотрудника.Вставить("Организация", Объект.Организация);
	ОписаниеСотрудника.Вставить("ДатаРасчета", ВремяРегистрации);	
	ОписаниеСотрудника.Вставить("Начисления", РасчетЗарплатыРасширенный.ПустаяТаблицаДанныеНачисленийДляРасчетаФОТ());
	ОписаниеСотрудника.Вставить("Показатели", РасчетЗарплатыРасширенный.ПустаяТаблицаДанныеПоказателейДляРасчетаФОТ());
	
	МассивНачислений = ОбщегоНазначения.ВыгрузитьКолонку(Объект.НачисленияСотрудника, "Начисление", Истина);
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(МассивНачислений, ПланыВидовРасчета.Начисления.ПустаяСсылка());
	
	ЗначенияРеквизитаРассчитывается = Новый Соответствие;
	Если МассивНачислений.Количество() > 0 Тогда 
		ЗначенияРеквизитаРассчитывается = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивНачислений, "Рассчитывается");
	КонецЕсли;
	
	// Все начисления сотрудника
	Для Каждого СтрокаНачисления Из Объект.НачисленияСотрудника Цикл
		НачислениеРассчитывается = ?(ЗначениеЗаполнено(СтрокаНачисления.Начисление), ЗначенияРеквизитаРассчитывается[СтрокаНачисления.Начисление], Истина);
		ДанныеНачисления = ОписаниеСотрудника.Начисления.Добавить();
		ДанныеНачисления.Начисление = СтрокаНачисления.Начисление;
		ДанныеНачисления.ДокументОснование = СтрокаНачисления.ДокументОснование;
		ДанныеНачисления.Размер = ?(НачислениеРассчитывается, 0, СтрокаНачисления.Размер);
	КонецЦикла;
	
	РассчитываемыеОбъекты.Вставить(Объект.Ссылка, Сотрудники);
	Сотрудники.Вставить(Объект.Сотрудник, ОписаниеСотрудника);
	
	// Расчет ФОТ
	РасчетЗарплатыРасширенный.РассчитатьФОТСотрудников(РассчитываемыеОбъекты, Объект.Организация, ВремяРегистрации);
	
	// Заполнение документа результатами расчета.
	ОписаниеОбъекта = РассчитываемыеОбъекты.Получить(Объект.Ссылка);
	ОписаниеСотрудника = ОписаниеОбъекта.Получить(Объект.Сотрудник);
	
	Объект.НачисленияСотрудника.Очистить();
	
	Для Каждого ОписаниеНачисления Из ОписаниеСотрудника.Начисления Цикл
		
		НовоеНачисление = Объект.НачисленияСотрудника.Добавить();
		НовоеНачисление.Начисление = ОписаниеНачисления.Начисление;
		НовоеНачисление.ДокументОснование = ОписаниеНачисления.ДокументОснование;
		НовоеНачисление.Размер = ОписаниеНачисления.Размер;
		
	КонецЦикла;
	
	РассчитатьФОТНаФорме(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьВремяРегистрации()
	
	ВремяРегистрации = ЗарплатаКадрыРасширенный.ВремяРегистрацииДокумента(Объект.Ссылка, Объект.ДатаОтмены);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеНадписей()
	
	МассивСотрудников = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Сотрудник);
	ЗарплатаКадрыРасширенный.УстановитьТекстНадписиОДокументахВведенныхНаДату(ЭтотОбъект, ВремяРегистрации, 
		МассивСотрудников, Объект.Ссылка, ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений, Объект.ИсправленныйДокумент);
	
КонецПроцедуры

// Работа с данными формы редактирования начислений.

&НаСервере
Функция АдресВХранилищеНачисленийИУдержаний(Сотрудник)
	
	ПараметрыОткрытия = ЗарплатаКадрыРасширенныйКлиентСервер.ПараметрыРедактированияСоставаНачисленийИУдержаний();
	
	ПараметрыОткрытия.ВладелецНачисленийИУдержаний = Сотрудник;
	ПараметрыОткрытия.ДатаРедактирования = ВремяРегистрации;
	ПараметрыОткрытия.Организация = Объект.Организация;
	ПараметрыОткрытия.РежимРаботы = 3;
	ПараметрыОткрытия.ДополнитьНедостающиеЗначенияПоказателей = Истина;
	
	ДополнитьСтруктуруНачислениямиИПоказателями(Сотрудник, ПараметрыОткрытия.Подразделение, ПараметрыОткрытия);
	
	Возврат ПоместитьВоВременноеХранилище(ПараметрыОткрытия, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ДополнитьСтруктуруНачислениямиИПоказателями(Сотрудник, Подразделение, ПараметрыОткрытия)
	
	МассивНачислений = Новый Массив;
	МассивПоказателей = Новый Массив;
	
	ИдентификаторСтрокиВидаРасчета = 1;
	
	// Добавление всех начислений сотрудника (кроме начисления шапки).
	Для Каждого СтрокаНачислений Из Объект.НачисленияСотрудника Цикл
		
		СтруктураНачисления = Новый Структура("Начисление,ДокументОснование,ИдентификаторСтрокиВидаРасчета,Размер");
		ЗаполнитьЗначенияСвойств(СтруктураНачисления, СтрокаНачислений);
		СтруктураНачисления.ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиВидаРасчета;
		МассивНачислений.Добавить(СтруктураНачисления);
		
		// Добавление показателей доплаты за совмещение.
		Если СтрокаНачислений.Начисление = Объект.Начисление Тогда
			
			СтруктураПоказателя = Новый Структура("Показатель,ИдентификаторСтрокиВидаРасчета,Значение");
			СтруктураПоказателя.Показатель = Справочники.ПоказателиРасчетаЗарплаты.РазмерДоплатыЗаСовмещение;
			СтруктураПоказателя.ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиВидаРасчета;
			СтруктураПоказателя.Значение = Объект.РазмерДоплаты;
			МассивПоказателей.Добавить(СтруктураПоказателя);
			
		КонецЕсли;
		
		ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиВидаРасчета + 1;
		
	КонецЦикла;
	
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.Используется = Истина;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.Таблица = МассивНачислений;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.ИзменятьСоставВидовРасчета = Ложь;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.ИзменятьЗначенияПоказателей = Ложь;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.НомерТаблицы = 1;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.ПоказатьФОТ = Истина;
	
	ПараметрыОткрытия.Показатели = МассивПоказателей;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачисленияИзВРеменногоХранилища(АдресВХранилище);
	
	ДанныеИзХранилища = ПолучитьИзВременногоХранилища(АдресВХранилище);
	Если ДанныеИзХранилища = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Сотрудник = ДанныеИзХранилища.ВладелецНачисленийИУдержаний;
	Если Сотрудник <> Объект.Сотрудник Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого НачислениеСотрудника Из ДанныеИзХранилища.Начисления Цикл
		
		СтрокиНачисления = Объект.НачисленияСотрудника.НайтиСтроки(Новый Структура("Начисление", НачислениеСотрудника.Начисление));
		Если СтрокиНачисления.Количество() > 0 Тогда
			СтрокиНачисления[0].Размер = НачислениеСотрудника.Размер;
		КонецЕсли;		
		
	КонецЦикла;
	
	РассчитатьФОТНаФорме(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти
