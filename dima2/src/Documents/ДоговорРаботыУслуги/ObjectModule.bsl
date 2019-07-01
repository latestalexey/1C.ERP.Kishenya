#Если Не ТолстыйКлиентУправляемоеПриложение Или Сервер Тогда

#Область ПрограммныйИнтерфейс

// Подсистема "Управление доступом".

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическоеЛицо");
	
КонецПроцедуры

// Подсистема "Управление доступом".

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если СпособОплаты = Перечисления.СпособыОплатыПоДоговоруГПХ.ПоАктамВыполненныхРабот Тогда
		МесяцНачисления = '00010101';
	Иначе
		МесяцНачисления = НачалоМесяца(ДатаОкончания);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадрыРасширенный.ПроверитьПериодРегистратораНачисленийУдержаний(ДатаНачала, ДатаОкончания, ЭтотОбъект, "ДатаОкончания", Отказ);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения, , Истина)
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	ДанныеОПлановыхНачислениях = ДанныеДляПроведения.ПлановыеНачисленияПоДоговорам;
	
	Для Каждого Строка Из ДанныеОПлановыхНачислениях Цикл
		
		Если Строка.ОплатаПоАктамВыполненныхРабот Тогда
			Продолжить;
		КонецЕсли;
		
		Если Строка.АктПроведен Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='На основании договора уже введен документ %1. Для проведения документа необходимо удалить акт выполненных работ или изменить вариант оплаты в договоре на ""по актам выполненных работ"".';uk='На підставі договору вже введений документ %1. Для проведення документа необхідно видалити акт виконаних робіт або змінити варіант оплати в договорі на ""по актам виконаних робіт"".'"), Строка.АктВыполненныхРабот);
			ВызватьИсключение ТекстОшибки;
			
		КонецЕсли;
		
		Если СпособОплаты = Перечисления.СпособыОплатыПоДоговоруГПХ.ВКонцеСрокаСАвансовымиПлатежами Тогда
			Движения.УсловияДоговораГПХ.Записывать = Истина;
		    НоваяСтрока = Движения.УсловияДоговораГПХ.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			НоваяСтрока.Период = ДатаНачала;
		Иначе
			Движения.ПлановыеНачисленияПоДоговорам.Записывать = Истина;
		    НоваяСтрока = Движения.ПлановыеНачисленияПоДоговорам.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		КонецЕсли;
		
	КонецЦикла;
	
	КадровыйУчетРасширенный.СформироватьДвиженияДоговоровГПХ(Движения, ДанныеДляПроведения.ПериодыДействияДоговоровГражданскоПравовогоХарактера);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает данные для формирования движений.
// Возвращает таблицу значений - данные, необходимые для формирования плановых начислений по договорам.
//
Функция ДанныеДляПроведения()
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоговорРаботыУслуги.Сотрудник,
	|	ДоговорРаботыУслуги.Организация,
	|	ДоговорРаботыУслуги.Ссылка КАК Договор,
	|	ДоговорРаботыУслуги.КодДохода КАК КодДохода,
	|	ДоговорРаботыУслуги.КатегорияЕСВ КАК КатегорияЕСВ,
	|	ДоговорРаботыУслуги.СпособОтраженияЗарплатыВБухучете,
	|	ДоговорРаботыУслуги.Подразделение,
	|	ДоговорРаботыУслуги.Сумма,
	|	НАЧАЛОПЕРИОДА(ДоговорРаботыУслуги.ДатаОкончания, МЕСЯЦ) КАК МесяцНачисления,
	|	ВЫБОР
	|		КОГДА ДоговорРаботыУслуги.СпособОплаты = ЗНАЧЕНИЕ(Перечисление.СпособыОплатыПоДоговоруГПХ.ПоАктамВыполненныхРабот)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОплатаПоАктамВыполненныхРабот,
	|	ВЫБОР
	|		КОГДА ДоговорРаботыУслуги.СпособОплаты = ЗНАЧЕНИЕ(Перечисление.СпособыОплатыПоДоговоруГПХ.ВКонцеСрокаСАвансовымиПлатежами)
	|			ТОГДА ДоговорРаботыУслуги.ДатаНачала
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ДоговорРаботыУслуги.ДатаНачала <= НАЧАЛОПЕРИОДА(ДоговорРаботыУслуги.ДатаОкончания, МЕСЯЦ)
	|					ТОГДА НАЧАЛОПЕРИОДА(ДоговорРаботыУслуги.ДатаОкончания, МЕСЯЦ)
	|				ИНАЧЕ ДоговорРаботыУслуги.ДатаНачала
	|			КОНЕЦ
	|	КОНЕЦ КАК ДатаНачала,
	|	ДоговорРаботыУслуги.ДатаОкончания,
	|	ДоговорРаботыУслуги.ЗаключенСоСтудентомРаботающимВСтудотряде,
	|	ДоговорРаботыУслуги.СтатьяФинансирования,
	|	ДоговорРаботыУслуги.СтатьяРасходов,
	|	ДоговорРаботыУслуги.Ссылка КАК ДоговорАкт,
	|	ЕСТЬNULL(АктПриемкиВыполненныхРаботОказанныхУслуг.Проведен, ЛОЖЬ) КАК АктПроведен,
	|	АктПриемкиВыполненныхРаботОказанныхУслуг.Ссылка КАК АктВыполненныхРабот,
	|	ДоговорРаботыУслуги.ДатаОкончания КАК ПланируемаяДатаВыплаты,
	|	ДоговорРаботыУслуги.РазмерПлатежа КАК РазмерЕжемесячногоАвансовогоПлатежа,
	|	ДоговорРаботыУслуги.Дата КАК Период,
	|	ДоговорРаботыУслуги.ФизическоеЛицо
	|ИЗ
	|	Документ.ДоговорРаботыУслуги КАК ДоговорРаботыУслуги
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АктПриемкиВыполненныхРаботОказанныхУслуг КАК АктПриемкиВыполненныхРаботОказанныхУслуг
	|		ПО ДоговорРаботыУслуги.Ссылка = АктПриемкиВыполненныхРаботОказанныхУслуг.Договор
	|ГДЕ
	|	ДоговорРаботыУслуги.Ссылка = &Ссылка";
	
	РезультатыЗапроса = Запрос.Выполнить();
	
	ДанныеДляПроведения = Новый Структура("ПлановыеНачисленияПоДоговорам,ПериодыДействияДоговоровГражданскоПравовогоХарактера");
	ДанныеДляПроведения.Вставить("ПлановыеНачисленияПоДоговорам", РезультатыЗапроса.Выгрузить());
	
	ПериодыДействияДоговоровГражданскоПравовогоХарактера = Новый Структура;
	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Вставить("Организация", Организация);
	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Вставить("Филиал", Организация);
	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Вставить("Сотрудник", Сотрудник);
	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Вставить("ФизическоеЛицо", ФизическоеЛицо);
	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Вставить("ДатаНачала", ДатаНачала);
	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Вставить("ДатаОкончания", ДатаОкончания);
	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Вставить("Подразделение", Подразделение);
	
	ДанныеДляПроведения.Вставить("ПериодыДействияДоговоровГражданскоПравовогоХарактера",
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПериодыДействияДоговоровГражданскоПравовогоХарактера));
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#КонецОбласти

#КонецЕсли
