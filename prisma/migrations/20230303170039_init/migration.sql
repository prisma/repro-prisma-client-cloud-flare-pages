-- CreateEnum
CREATE TYPE "UserModelKind" AS ENUM ('User');

-- CreateEnum
CREATE TYPE "AccountModelKind" AS ENUM ('Account');

-- CreateEnum
CREATE TYPE "AccountProviderName" AS ENUM ('github');

-- CreateEnum
CREATE TYPE "AccountProviderKind" AS ENUM ('oauth');

-- CreateEnum
CREATE TYPE "OrganizationModelKind" AS ENUM ('Organization');

-- CreateEnum
CREATE TYPE "OrganizationMembershipModelKind" AS ENUM ('OrganizationMembership');

-- CreateEnum
CREATE TYPE "ProjectModelKind" AS ENUM ('Project');

-- CreateEnum
CREATE TYPE "EnvironmentModelKind" AS ENUM ('Environment');

-- CreateEnum
CREATE TYPE "DatabaseLinkModelKind" AS ENUM ('DatabaseLink');

-- CreateEnum
CREATE TYPE "NotificationModelKind" AS ENUM ('Notification');

-- CreateEnum
CREATE TYPE "NotificationVariantTag" AS ENUM ('NotificationEarlyAdopterPlanRetired');

-- CreateEnum
CREATE TYPE "NotificationEarlyAdopterPlanRetiredKind" AS ENUM ('NotificationEarlyAdopterPlanRetired');

-- CreateTable
CREATE TABLE "User" (
    "kind" "UserModelKind" NOT NULL DEFAULT 'User',
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deactivated" BOOLEAN,
    "deactivatedAt" TIMESTAMP(3),
    "displayName" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "image" TEXT,
    "stripeCustomerId" TEXT NOT NULL,
    "auth0UserId" TEXT,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Account" (
    "kind" "AccountModelKind" NOT NULL DEFAULT 'Account',
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "providerName" "AccountProviderName" NOT NULL,
    "providerKind" "AccountProviderKind" NOT NULL,
    "providerAccountId" TEXT NOT NULL,
    "refreshToken" TEXT,
    "accessToken" TEXT NOT NULL,
    "accessTokenExpires" TIMESTAMP(3),
    "userId" TEXT NOT NULL,

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Organization" (
    "kind" "OrganizationModelKind" NOT NULL DEFAULT 'Organization',
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "displayName" TEXT NOT NULL,

    CONSTRAINT "Organization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrganizationMembership" (
    "kind" "OrganizationMembershipModelKind" NOT NULL DEFAULT 'OrganizationMembership',
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "organizationId" TEXT,

    CONSTRAINT "OrganizationMembership_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Project" (
    "kind" "ProjectModelKind" NOT NULL DEFAULT 'Project',
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "displayName" TEXT NOT NULL,
    "deactivated" BOOLEAN NOT NULL DEFAULT false,
    "deactivatedOn" TIMESTAMP(3),
    "organizationId" TEXT,

    CONSTRAINT "Project_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Environment" (
    "kind" "EnvironmentModelKind" NOT NULL DEFAULT 'Environment',
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "displayName" TEXT NOT NULL,
    "isDefault" BOOLEAN NOT NULL,
    "projectId" TEXT NOT NULL,

    CONSTRAINT "Environment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DatabaseLink" (
    "kind" "DatabaseLinkModelKind" NOT NULL DEFAULT 'DatabaseLink',
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "connectionString" TEXT NOT NULL,
    "environmentId" TEXT NOT NULL,

    CONSTRAINT "DatabaseLink_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Notification" (
    "kind" "NotificationModelKind" NOT NULL DEFAULT 'Notification',
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "acknowledged" BOOLEAN NOT NULL DEFAULT false,
    "variantTag" "NotificationVariantTag" NOT NULL,
    "recipientId" TEXT NOT NULL,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_stripeCustomerId_key" ON "User"("stripeCustomerId");

-- CreateIndex
CREATE UNIQUE INDEX "User_auth0UserId_key" ON "User"("auth0UserId");

-- CreateIndex
CREATE UNIQUE INDEX "Account_providerKind_providerAccountId_key" ON "Account"("providerKind", "providerAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "DatabaseLink_environmentId_key" ON "DatabaseLink"("environmentId");

-- AddForeignKey
ALTER TABLE "Account" ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationMembership" ADD CONSTRAINT "OrganizationMembership_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationMembership" ADD CONSTRAINT "OrganizationMembership_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Project" ADD CONSTRAINT "Project_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Environment" ADD CONSTRAINT "Environment_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DatabaseLink" ADD CONSTRAINT "DatabaseLink_environmentId_fkey" FOREIGN KEY ("environmentId") REFERENCES "Environment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_recipientId_fkey" FOREIGN KEY ("recipientId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
