#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

	
#Область ПрограммныйИнтерфейс

#Область ПроцедурыИФункцииЗаполненияДокумента

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
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическиеЛица.ФизическоеЛицо");
	
КонецПроцедуры
// Подсистема "Управление доступом".

#КонецОбласти

#КонецОбласти
	
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	
КонецПроцедуры

#КонецОбласти

Процедура ЗаполнитьПоВыплатам() Экспорт

	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхтаблиц;
	Запрос.УстановитьПараметр("ПериодС", ПериодС);
	Запрос.УстановитьПараметр("ПериодПо", ПериодПо);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ГруппаУчета", Справочники.ГруппыУчетаНачисленийИУдержаний.НачисленияФСС);
	Запрос.УстановитьПараметр("Расход", ВидДвиженияНакопления.Расход);
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	               |	ЗарплатаКВыплате.ДокументОснование,
				   |	ЗарплатаКВыплате.Регистратор.Дата КАК ДатаВыплаты
				   |ПОМЕСТИТЬ ВТВыплаты
				   |ИЗ
	               |	РегистрНакопления.ЗарплатаКВыплате КАК ЗарплатаКВыплате
				   |ГДЕ
				   |    ЗарплатаКВыплате.ВидДвижения = &Расход
				   |    И ЗарплатаКВыплате.Организация = &Организация
				   |    И ЗарплатаКВыплате.ГруппаУчетаНачислений = &ГруппаУчета
				   |    И ЗарплатаКВыплате.Регистратор.Дата МЕЖДУ &ПериодС И &ПериодПо
				   |;
				   |/////////////////////////////////////////////////////
				   |ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	               |	ПодтверждениеВыплатЗаСчетФСС.ДокументОснование
				   |ПОМЕСТИТЬ ВТПодтверждения
				   |ИЗ
	               |	Документ.ПодтверждениеВыплатЗаСчетФСС.Выплаты КАК ПодтверждениеВыплатЗаСчетФСС
				   |    ВНУТРЕННЕЕ СОЕДИНЕНИЕ
				   |	ВТВыплаты КАК Выплаты
				   |    ПО Выплаты.ДокументОснование = ПодтверждениеВыплатЗаСчетФСС.ДокументОснование
				   |ГДЕ
				   |    ПодтверждениеВыплатЗаСчетФСС.Ссылка.Проведен
				   |    И ПодтверждениеВыплатЗаСчетФСС.Ссылка <> &Ссылка
				   |;
				   |/////////////////////////////////////////////////////
				   |ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
				   |	РасчетыСФондамиПоПособиям.Сотрудник,
				   |	РасчетыСФондамиПоПособиям.ДокументОснование,
				   |	РасчетыСФондамиПоПособиям.Сумма,
				   |	РасчетыСФондамиПоПособиям.Заявление,
				   |	Выплаты.ДатаВыплаты
				   |ИЗ
	               |	РегистрНакопления.РасчетыСФондамиПоПособиям КАК РасчетыСФондамиПоПособиям
				   |    ВНУТРЕННЕЕ СОЕДИНЕНИЕ
				   |	ВТВыплаты КАК Выплаты
				   |    ПО Выплаты.ДокументОснование = РасчетыСФондамиПоПособиям.ДокументОснование
				   |    ЛЕВОЕ СОЕДИНЕНИЕ
				   |	ВТПодтверждения КАК Подтверждения
				   |    ПО Подтверждения.ДокументОснование = РасчетыСФондамиПоПособиям.ДокументОснование
				   |ГДЕ
				   |    РасчетыСФондамиПоПособиям.ВидДвижения = &Расход
				   |    И Подтверждения.ДокументОснование ЕСТЬ NULL
				   |УПОРЯДОЧИТЬ ПО
				   |    Сотрудник, ДатаВыплаты
				   |";
	Выплаты.Загрузить(Запрос.Выполнить().Выгрузить());			   
	
	
КонецПроцедуры




#КонецЕсли

