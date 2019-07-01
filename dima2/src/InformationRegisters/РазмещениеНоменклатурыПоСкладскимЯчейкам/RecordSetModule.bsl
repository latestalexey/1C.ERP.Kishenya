#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры
 
Процедура ПриЗаписи(Отказ, Замещение)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	//Основная ячейка должна быть одна
	//Если набор записывает еще одну основную ячейку, выдается ошибка
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РазмещениеНоменклатурыПоСкладскимЯчейкам.Номенклатура,
	|	РазмещениеНоменклатурыПоСкладскимЯчейкам.Склад,
	|	РазмещениеНоменклатурыПоСкладскимЯчейкам.Помещение,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ РазмещениеНоменклатурыПоСкладскимЯчейкам.Ячейка) КАК Ячейка
	|ИЗ
	|	РегистрСведений.РазмещениеНоменклатурыПоСкладскимЯчейкам КАК РазмещениеНоменклатурыПоСкладскимЯчейкам
	|ГДЕ
	|	РазмещениеНоменклатурыПоСкладскимЯчейкам.ОсновнаяЯчейка
	|	И РазмещениеНоменклатурыПоСкладскимЯчейкам.Номенклатура В(&Номенклатура)
	|	И РазмещениеНоменклатурыПоСкладскимЯчейкам.Склад В(&Склад)
	|	И РазмещениеНоменклатурыПоСкладскимЯчейкам.Помещение В(&Помещение)
	|
	|СГРУППИРОВАТЬ ПО
	|	РазмещениеНоменклатурыПоСкладскимЯчейкам.Склад,
	|	РазмещениеНоменклатурыПоСкладскимЯчейкам.Номенклатура,
	|	РазмещениеНоменклатурыПоСкладскимЯчейкам.Помещение
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ РазмещениеНоменклатурыПоСкладскимЯчейкам.Ячейка) > 1";
	
	ТаблицаНабора = Выгрузить();
	
	Запрос.УстановитьПараметр("Номенклатура", ТаблицаНабора.ВыгрузитьКолонку("Номенклатура"));
	Запрос.УстановитьПараметр("Склад", ТаблицаНабора.ВыгрузитьКолонку("Склад"));
	Запрос.УстановитьПараметр("Помещение", ТаблицаНабора.ВыгрузитьКолонку("Помещение"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ТекстСообщения = НСтр("ru='По номенклатуре ""%Номенклатура%"" на складе ""%Склад%""
        | назначаются две основные ячейки!'
        |;uk='По номенклатурі ""%Номенклатура%"" на складі ""%Склад%""
        |призначаються дві основні комірки!'");
		
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Номенклатура%",Выборка.Номенклатура);
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Склад%",СкладыСервер.ПолучитьПредставлениеСклада(Выборка.Склад,Выборка.Помещение));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
		
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#КонецЕсли