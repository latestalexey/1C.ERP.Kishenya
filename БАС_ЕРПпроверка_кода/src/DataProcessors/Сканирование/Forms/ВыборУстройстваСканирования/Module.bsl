
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	КоличествоЭлементов = 0;
	Если ФайловыеФункцииСлужебныйКлиент.ПроинициализироватьКомпоненту() Тогда
		МассивУстройств = ФайловыеФункцииСлужебныйКлиент.ПолучитьУстройства();
		Для Каждого Строка Из МассивУстройств Цикл
			КоличествоЭлементов = КоличествоЭлементов + 1;
			Элементы.ИмяУстройства.СписокВыбора.Добавить(Строка);
		КонецЦикла;
	КонецЕсли;
	Если КоличествоЭлементов = 0 Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru='Не установлен сканер. Обратитесь к администратору программы.';uk='Не встановлений сканер. Зверніться до адміністратора програми.'"));
	Иначе
		Элементы.ИмяУстройства.РежимВыбораИзСписка = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьСканер(Команда)
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
		"НастройкиСканирования/ИмяУстройства",
		СистемнаяИнформация.ИдентификаторКлиента,
		ИмяУстройства);
	ОбновитьПовторноИспользуемыеЗначения();
	Закрыть(ИмяУстройства);
КонецПроцедуры

#КонецОбласти