
&НаКлиенте
Процедура ИмпортироватьСертификат(Команда)
	
	ТекстПодсказки = НСтр("ru='Укажите логическое хранилище';uk='Вкажіть логічне сховище'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	ОписаниеОповещения = Новый ОписаниеОповещения("ИмпортироватьСертификатПоказатьВводЗначенияЗавершение", ЭтотОбъект);
	ПоказатьВводЗначения(ОписаниеОповещения, , ТекстПодсказки, Тип("ПеречислениеСсылка.ЛогическиеХранилищаСертификатов"));  
	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортироватьСертификатПоказатьВводЗначенияЗавершение(ЛогическоеХранилище, ДополнительныеПараметры) Экспорт
	
	Если ЛогическоеХранилище <> Неопределено Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ИмпортироватьСертификатПоместитьФайлЗавершение", ЭтотОбъект, ЛогическоеХранилище);
		НачатьПомещениеФайла(ОписаниеОповещения,,, Истина, УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортироватьСертификатПоместитьФайлЗавершение(Результат, АдресСертификата, ВыбранноеИмяФайла, ЛогическоеХранилище) Экспорт
	
	Если Результат Тогда
		
		ИмпортироватьСертификатНаСервере(АдресСертификата, ЛогическоеХранилище);
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИмпортироватьСертификатНаСервере(АдресСертификата, ЛогическоеХранилище)
	
	Сертификат = ПолучитьИзВременногоХранилища(АдресСертификата);
	ХранилищеСертификатовВМоделиСервиса.ЗарегистрироватьСертификат(Сертификат, ЛогическоеХранилище);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭкспортироватьСертификат(Команда)
	
	ТекущаяЗапись = Элементы.Список.ТекущаяСтрока;
	Если ТекущаяЗапись <> Неопределено Тогда
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			ИмяФайлаСертификата = ТекущиеДанные.Наименование + ".cer";
		Иначе
			ИмяФайлаСертификата = "Сертификат.cer";
		КонецЕсли;	
		АдресФайла = ПолучитьСертификатИзХранилища(ТекущаяЗапись, УникальныйИдентификатор);
		ПолучитьФайл(АдресФайла, ИмяФайлаСертификата, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСертификатИзХранилища(КлючЗаписи, Идентификатор)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ХранилищеСертификатов.Сертификат
	|ИЗ
	|	РегистрСведений.ХранилищеСертификатов КАК ХранилищеСертификатов
	|ГДЕ
	|	ХранилищеСертификатов.ЛогическоеХранилище = &ЛогическоеХранилище
	|	И ХранилищеСертификатов.Отпечаток = &Отпечаток";
	Запрос.УстановитьПараметр("Отпечаток", КлючЗаписи.Отпечаток);
	Запрос.УстановитьПараметр("ЛогическоеХранилище", КлючЗаписи.ЛогическоеХранилище);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат ПоместитьВоВременноеХранилище(Выборка.Сертификат.Получить(), Идентификатор);
	
КонецФункции
