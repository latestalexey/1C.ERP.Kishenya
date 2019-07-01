#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения, , Истина);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ДанныеЗаполнения.Свойство("Организация", Организация);
		ДанныеЗаполнения.Свойство("Сотрудник", Сотрудник);
		
		// Данные о заработке заполняем безусловно.
		АдресДанныхОЗаработкеВХранилище = Неопределено;
		Если ДанныеЗаполнения.Свойство("АдресДанныхОЗаработкеВХранилище", АдресДанныхОЗаработкеВХранилище) Тогда
			ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ПолучитьИзВременногоХранилища(АдресДанныхОЗаработкеВХранилище), ДанныеОЗаработке);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ТаблицаДвижений = СформироватьДвиженияДанныеОбУчтенныхСуммахДляРасчетаСреднегоЗаработкаФСС(ЭтотОбъект.Ссылка);
	ПроведениеСервер.ОтразитьДвижения(ТаблицаДвижений, Движения.ДанныеОбУчтенныхСуммахДляРасчетаСреднегоЗаработкаФСС, Отказ);	
	
КонецПроцедуры


Функция СформироватьДвиженияДанныеОбУчтенныхСуммахДляРасчетаСреднегоЗаработкаФСС(ДокументОбъект)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОбъект",ДокументОбъект);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(ВходящаяСправкаОРасчетеБольничногоДанныеОЗаработке.Заработок) КАК УчтеннаяСумма,
		|	ВходящаяСправкаОРасчетеБольничногоДанныеОЗаработке.РасчетныйМесяц КАК Месяц,
		|	ВходящаяСправкаОРасчетеБольничного.Организация КАК ГоловнаяОрганизация,
		|	ВходящаяСправкаОРасчетеБольничного.ФизическоеЛицо,
		|	ВходящаяСправкаОРасчетеБольничного.НомерЛисткаНетрудоспособности КАК НомерЛисткаНетрудоспособности,
		|	ВходящаяСправкаОРасчетеБольничного.Дата КАК Период
		|ИЗ
		|	Документ.ВходящаяСправкаОРасчетеБольничного.ДанныеОЗаработке КАК ВходящаяСправкаОРасчетеБольничногоДанныеОЗаработке
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВходящаяСправкаОРасчетеБольничного КАК ВходящаяСправкаОРасчетеБольничного
		|		ПО ВходящаяСправкаОРасчетеБольничногоДанныеОЗаработке.Ссылка = ВходящаяСправкаОРасчетеБольничного.Ссылка
		|ГДЕ
		|	ВходящаяСправкаОРасчетеБольничногоДанныеОЗаработке.Ссылка = &ДокументОбъект
		|
		|СГРУППИРОВАТЬ ПО
		|	ВходящаяСправкаОРасчетеБольничного.ФизическоеЛицо,
		|	ВходящаяСправкаОРасчетеБольничного.Организация,
		|	ВходящаяСправкаОРасчетеБольничного.НомерЛисткаНетрудоспособности,
		|	ВходящаяСправкаОРасчетеБольничногоДанныеОЗаработке.РасчетныйМесяц,
		|	ВходящаяСправкаОРасчетеБольничного.Дата";
	
	Возврат Запрос.Выполнить().Выгрузить()
	
КонецФункции	

#КонецОбласти

#КонецЕсли
