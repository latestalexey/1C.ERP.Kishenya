#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы


Процедура ИсправитьДвижения_ДанныеДляОбновления(Параметры) Экспорт 
	
	ПолноеИмяРегистра = "РегистрНакопления.ТоварыКОтбору";
	ИмяРегистра       = "ТоварыКОтбору";
	
#Область РасходныйОрдерНаТовары
	ТекстЗапросаАдаптированный = Документы.РасходныйОрдерНаТовары.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
        ТекстЗапросаАдаптированный,
		ПолноеИмяРегистра,
		"Документ.РасходныйОрдерНаТовары"
    );
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
#КонецОбласти
	
#Область ОрдерНаПеремещениеТоваров
	ТекстЗапросаАдаптированный = Документы.ОрдерНаПеремещениеТоваров.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
        ТекстЗапросаАдаптированный,
		ПолноеИмяРегистра,
		"Документ.ОрдерНаПеремещениеТоваров"
    );
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
#КонецОбласти

КонецПроцедуры

Процедура ИсправитьДвижения(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.РасходныйОрдерНаТовары");
	Регистраторы.Добавить("Документ.ОрдерНаПеремещениеТоваров");
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
        Регистраторы,
		"РегистрНакопления.ТоварыКОтбору",
		Параметры.Очередь
    );
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры



#КонецОбласти

#КонецОбласти


#КонецЕсли