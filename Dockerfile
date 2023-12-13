﻿FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /app
COPY ["PriceNegotiationAPI/PriceNegotiationAPI.csproj", "PriceNegotiationAPI/"]
RUN dotnet restore "PriceNegotiationAPI/PriceNegotiationAPI.csproj"
COPY . .
WORKDIR "PriceNegotiationAPI"
RUN dotnet build "PriceNegotiationAPI.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "PriceNegotiationAPI.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PriceNegotiationAPI.dll"]